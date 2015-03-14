function example2
ME = MException('MyComponent:noSuchVariable', ... 
    'Variable %s not found','avar1');
 throw(ME)
end
