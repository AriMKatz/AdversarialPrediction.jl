# negative of obj, since the original formulation is max_\theta
# whereas the optimizer only support minimization

# all the opt in the metric needs to be done in cpu

### objective ###
function ap_objective(ps::AbstractVector, y::AbstractVector, pm::PerformanceMetric; args...)
    obj, _ = objective(pm, ps, y; args...)
    obj = obj + dot(ps, y)
    return -obj
end

### obj and grad ###
function ap_obj_grad(ps::AbstractVector, y::AbstractVector, pm::PerformanceMetric; args...)
    obj, q = objective(pm, data(ps), y; args...)
    obj = obj + dot(ps, y)
    grad = (q - y) 
    return -obj, Δ -> (grad, nothing, nothing)
end


### Tracker for autograd ###
function ap_objective(ps::TrackedArray, y::AbstractVector, pm::PerformanceMetric; args...)
    track(ap_objective, ps, y, pm; args...)
end

@grad function ap_objective(ps::AbstractVector, y::AbstractVector, pm::PerformanceMetric; args...)
    return ap_obj_grad(data(ps), y, pm; args...)
end

