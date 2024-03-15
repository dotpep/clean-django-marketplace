from dataclasses import dataclass
from datetime import datetime


# Domain Entity (simplified DDD without object value and validation) for retrive DTO
@dataclass
class Product:
    """Domain Entity of Product"""
    id: int
    title: str
    description: str
    created_at: datetime
    updated_at: datetime
