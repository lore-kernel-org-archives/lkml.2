Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067Ab2JZDbT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 23:31:19 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:58980 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756017Ab2JZDbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 23:31:16 -0400
X-AuditID: cbfee61b-b7f616d00000319b-9c-508a0402821f
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
To: "'Vyacheslav Dubeyko'" <slava@dubeyko.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, viro@zeniv.linux.org.uk, arnd@arndb.de,
        tytso@mit.edu, chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com
References: <001001cdb0c5$2ac96520$805c2f60$%kim@samsung.com>
 <001201cdb0c5$bdf728f0$39e57ad0$%kim@samsung.com>
 <1351077945.2097.9.camel@slavad-ubuntu>
In-reply-to: <1351077945.2097.9.camel@slavad-ubuntu>
Subject: RE: [PATCH 02/16 v2] f2fs: add on-disk layout
Date: Fri, 26 Oct 2012 12:31:14 +0900
Message-id: <00e601cdb32a$59fbe090$0df3a1b0$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2x2lfwNy8RW3n1SqS1QwOJjZfvuwBI/NQA
Content-language: en-us
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsVy+t8zA10mlq4Ag+udmhZ79p5ksbi8aw6b
	A5PH501yAYxRXDYpqTmZZalF+nYJXBmzju5lK/ilXDHh5T72BsYlMl2MnBwSAiYS+w6uZ4Ow
	xSQu3IOwhQSWMUqsvRAKU9P05Q5zFyMXUHw6o8TG3UcYIZx/jBI3r/8FynBwsAloS2zebwDS
	ICKgI/Fj5Qp2kBpmgYeMEnNunmCHaJjNKHFv23MmkCpOoLH/mqezgtjCAmYSfW8fsoMMYhFQ
	lVi8MxEkzCtgK3F4+0w2CFtQ4sfkeywgNrOAusSkeYuYIWx5ic1r3oLdIAEUf/RXF+IGI4mN
	p6+yQpSIS0x6ADKdE2i6gMS3yYdYIMplJTYdAPtLQmAVu8SfVUtYIB6WlDi44gbLBEaJWUg2
	z0KyeRaSzbOQrFjAyLKKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIyTGpHcwrmqwOMQowMGo
	xMO7Ia0zQIg1say4MvcQowQHs5II7+6pQCHelMTKqtSi/Pii0pzU4kOMPkCXT2SWEk3OB8Z/
	Xkm8obGxiZmJqYm5pam5KQ5hJXHeZo+UACGB9MSS1OzU1ILUIphxTBycUg2MkjdsE5IP9T/2
	dlPdu0Z5peOZxCYR/x2bhWabWDjKiFi4ar4w2iRSyXhtIaOWUvRxwZiniYWLRcprrnu8Kud6
	tcClYOYkFoOUVaek4lVO1orI2JWpz1xXWLvzTa3Yvfbb/8NsH8odsue33vHTQuudSoPmiZW5
	9lyvHnHHyGzJWnTm7o2ZH/mVWIozEg21mIuKEwH+Fveo3gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNIsWRmVeSWpSXmKPExsVy+t9jQV0mlq4Ag6VNKhZ79p5ksbi8aw6b
	A5PH501yAYxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4B
	um6ZOUCjlRTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGEdYwZs47uZSv4pVwx
	4eU+9gbGJTJdjJwcEgImEk1f7jBD2GISF+6tZ+ti5OIQEpjOKLFx9xFGCOcfo8TN63+Bqjg4
	2AS0JTbvNwBpEBHQkfixcgU7SA2zwENGiTk3T7BDNMxmlLi37TkTSBUn0Ip/zdNZQWxhATOJ
	vrcP2UEGsQioSizemQgS5hWwlTi8fSYbhC0o8WPyPRYQm1lAXWLSvEXMELa8xOY1b8FukACK
	P/qrC3GDkcTG01dZIUrEJSY9eMg+gVFoFpJJs5BMmoVk0iwkLQsYWVYxiqYWJBcUJ6XnGukV
	J+YWl+al6yXn525iBMfwM+kdjKsaLA4xCnAwKvHwbkjrDBBiTSwrrsw9xCjBwawkwrt7KlCI
	NyWxsiq1KD++qDQntfgQow/QnxOZpUST84HpJa8k3tDYxMzI0sjMwsjE3ByHsJI4b7NHSoCQ
	QHpiSWp2ampBahHMOCYOTqkGxpImAV853o+m7I9OiGmfatzVFZ5yWHdWuc9K7oKArEo7vRSW
	u25fn3e9nKvSsuJPJ8uf0zbMGS3MT/w278reOzeA1SdEONP1gB6bxIvUVUerayYfDK39uMW1
	uvR/X/2MyqyKL/4XG7sPSRcs4eHNkJx0VtAt0GmZ7UGr5k93TyV27ktOOhGixFKckWioxVxU
	nAgAqOfg1w4DAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[snip]
> > +#define F2FS_SUPER_MAGIC	0xF2F52010
> > +#define F2FS_SUPER_OFFSET	0		/* start sector # for sb */
> 
> Does f2fs superblock really haven't any offset from the volume begin?

The reason that I changed this from 1 to 0 is due to the failure during android
recovery. I don't know why the recovery is failed when the offset is 1, but it
works fine after the offset is changed to 0.
I suspect that mount procedure inspects the 0'th offset to figure out what file
system is installed by checking some kind of magic numbers.
Sometimes, we've seen that the mount program tries to load previously installed
file system even though mkfs.f2fs was conducted.
Would you recommend something?

> 
> > +#define F2FS_BLKSIZE		4096
> > +#define F2FS_MAX_EXTENSION	64
> > +
> > +#define NULL_ADDR		0x0U
> > +#define NEW_ADDR		-1U
> 
> Does NULL_ADDR and NEW_ADDR declarations really need? Does kernel
> haven't any analogous?

These are used for F2FS-specific block allocation, so for readability,
I don't want to change this.

> 
> > +
> > +#define F2FS_ROOT_INO(sbi)	(sbi->root_ino_num)
> > +#define F2FS_NODE_INO(sbi)	(sbi->node_ino_num)
> > +#define F2FS_META_INO(sbi)	(sbi->meta_ino_num)
> > +
> > +#define GFP_F2FS_MOVABLE	(__GFP_WAIT | __GFP_IO | __GFP_ZERO)
> > +
> > +#define MAX_ACTIVE_LOGS	16
> > +#define MAX_ACTIVE_NODE_LOGS	8
> > +#define MAX_ACTIVE_DATA_LOGS	8
> 
> I think that it makes sense to comment the reasons of such limitations
> in MAX_ACTIVE_LOGS, MAX_ACTIVE_NODE_LOGS, MAX_ACTIVE_DATA_LOGS.

The maximum number of logs is suggested by arnd before.
As I understood, why he suggested such a quite large number is for further
optimization of multiple logs without any on-disk layout changes.
And, I think it is quite enough.

> 
> > +
> > +/*
> > + * For superblock
> > + */
> > +struct f2fs_super_block {
> > +	__le32 magic;		/* Magic Number */
> > +	__le16 major_ver;	/* Major Version */
> > +	__le16 minor_ver;	/* Minor Version */
> > +	__le32 log_sectorsize;	/* log2 (Sector size in bytes) */
> > +	__le32 log_sectors_per_block;	/* log2 (Number of sectors per block */
> > +	__le32 log_blocksize;	/* log2 (Block size in bytes) */
> > +	__le32 log_blocks_per_seg; /* log2 (Number of blocks per segment) */
> 
> From my point of view, __le32 is big data type for log2 (<value>). What
> do you think?
> 

Right, but it is superblock. Should we have to consider space overhead?

> > +	__le32 segs_per_sec;	/* Number of segments per section */
> > +	__le32 secs_per_zone;	/* Number of sections per zone */
> > +	__le32 checksum_offset;	/* Checksum position in this super block */
> > +	__le64 block_count;	/* Total number of blocks */
> > +	__le32 section_count;	/* Total number of sections */
> > +	__le32 segment_count;	/* Total number of segments */
> > +	__le32 segment_count_ckpt; /* Total number of segments
> > +				      in Checkpoint area */
> > +	__le32 segment_count_sit; /* Total number of segments
> > +				     in Segment information table */
> > +	__le32 segment_count_nat; /* Total number of segments
> > +				     in Node address table */
> > +	/*Total number of segments in Segment summary area */
> > +	__le32 segment_count_ssa;
> > +	/* Total number of segments in Main area */
> > +	__le32 segment_count_main;
> > +	__le32 failure_safe_block_distance;
> > +	__le32 segment0_blkaddr;	/* Start block address of Segment 0 */
> > +	__le32 start_segment_checkpoint; /* Start block address of ckpt */
> > +	__le32 sit_blkaddr;	/* Start block address of SIT */
> > +	__le32 nat_blkaddr;	/* Start block address of NAT */
> > +	__le32 ssa_blkaddr;     /* Start block address of SSA */
> > +	__le32 main_blkaddr;	/* Start block address of Main area */
> > +	__le32 root_ino;	/* Root directory inode number */
> > +	__le32 node_ino;	/* node inode number */
> > +	__le32 meta_ino;	/* meta inode number */
> > +	__le32 volume_serial_number;	/* VSN is optional field */
> 
> Usually, it is used 128-bits UUID for serial number. Why do you use
> __le32 as volume_serial_number?

Ok, I'll change.

[snip]
> > +/*
> > + * For directory operations
> > + */
> > +#define F2FS_DOT_HASH		0
> > +#define F2FS_DDOT_HASH		F2FS_DOT_HASH
> > +#define F2FS_MAX_HASH		(~((0x3ULL) << 62))
> > +#define F2FS_HASH_COL_BIT	((0x1ULL) << 63)
> > +
> > +typedef __le32	f2fs_hash_t;
> > +
> > +#define F2FS_NAME_LEN		8
> 
> It exists F2FS_MAX_NAME_LEN. I think that it makes sense to comment here
> purpose of F2FS_NAME_LEN declaration.

Ok, thanks.

---
Jaegeuk Kim
Samsung


