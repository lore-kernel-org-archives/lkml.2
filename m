Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328Ab2JWGa7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 02:30:59 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:46800 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755274Ab2JWGaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 02:30:55 -0400
X-AuditID: cbfee61a-b7fa66d0000004cf-e9-5086399e5bea
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
To: "'NeilBrown'" <neilb@suse.de>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, viro@zeniv.linux.org.uk, arnd@arndb.de,
        tytso@mit.edu, chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com
References: <001001cdb0c5$2ac96520$805c2f60$%kim@samsung.com>
 <001201cdb0c5$bdf728f0$39e57ad0$%kim@samsung.com>
 <20121023144640.228d919e@notabene.brown>
In-reply-to: <20121023144640.228d919e@notabene.brown>
Subject: RE: [PATCH 02/16 v2] f2fs: add on-disk layout
Date: Tue, 23 Oct 2012 15:30:53 +0900
Message-id: <008f01cdb0e7$f3e8d9f0$dbba8dd0$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2w0P+Bt2NZXIwZTXGCGng0s8uOfQAFpWhA
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsVy+t8zA915lm0BBptbJC327D3JYnF51xw2
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDL2bPvMVNAmVrHg/CP2BsY+wS5GTg4JAROJF3c2M0PY
	YhIX7q1n62Lk4hASWMYo8Wn+S3aYoqPd95ghEtMZJT633mWFcP4xSqzad4Wxi5GDg01AW2Lz
	fgOQBhEBeYlVfccYQWqYBR4ySsy5eQJskpDAHEaJN9+CQWxOAVOJ/Q0zWUFsYQEzib63D8Fq
	WARUJS6+OscGYvMK2Er8bP3EAmELSvyYfI8FZBezgJ7E/YtaIGFmoF2b17xlBglLCKhLPPqr
	C3GCkcSblbfZIEpEJPa9eMcIMV1A4tvkQywQ5bISmw6AvSUhsIld4mX3VyaIfyUlDq64wTKB
	UWIWksWzEBbPQrJ4FpINCxhZVjGKphYkFxQnpeca6hUn5haX5qXrJefnbmKERJjUDsaVDRaH
	GAU4GJV4eC2OtAYIsSaWFVfmHmKU4GBWEuFVDgAK8aYkVlalFuXHF5XmpBYfYvQBOnwis5Ro
	cj4w+vNK4g2NjU3MTExNzC1NzU1xCCuJ8zZ7pAQICaQnlqRmp6YWpBbBjGPi4JRqYDz6JoI7
	gXfy9LTm6M0ZUUsbtM7Xb1aRd9pe1sqgu9hKem/Wh0OPs+s7ErbdLSrd8869jLd8w+T3bC6K
	IrbZYbHveYqvh925z3dS8Vr8maANtZEPfovnPLPzmvT+fIxDzSvGk1+WsUxUUC8/+PXEL6He
	+dE2B2q2Hd9zy0j88I2aH2Kngmv+CiqxFGckGmoxFxUnAgAVwiG33QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJIsWRmVeSWpSXmKPExsVy+t9jQd15lm0BBj/fiFjs2XuSxeLyrjls
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFm7Nn2mamgTaxi
	wflH7A2MfYJdjJwcEgImEke77zFD2GISF+6tZ+ti5OIQEpjOKPG59S4rhPOPUWLVviuMXYwc
	HGwC2hKb9xuANIgIyEus6jvGCFLDLPCQUWLOzRPsIAkhgTmMEm++BYPYnAKmEvsbZrKC2MIC
	ZhJ9bx+C1bAIqEpcfHWODcTmFbCV+Nn6iQXCFpT4MfkeC8guZgE9ifsXtUDCzEC7Nq95ywwS
	lhBQl3j0VxfiBCOJNytvs0GUiEjse/GOcQKj0Cwkg2YhDJqFZNAsJB0LGFlWMYqmFiQXFCel
	5xrqFSfmFpfmpesl5+duYgTH7zOpHYwrGywOMQpwMCrx8FocaQ0QYk0sK67MPcQowcGsJMKr
	HAAU4k1JrKxKLcqPLyrNSS0+xOgD9OZEZinR5HxgaskriTc0NjEzsjQyszAyMTfHIawkztvs
	kRIgJJCeWJKanZpakFoEM46Jg1OqgTH+l+78A1nqLKcsQvP2xcvcPBDUt2gKS9Km5fGizMXd
	vwXdI3ZazF4jt41zutavg17yP4oXWspf/mU/+ZPaDWeBwuV/8qaWfpKVfOLmxV/fvEhIX9jX
	vK19ZdtbkQDHK9vFSwxDPkyPeZHit+CRwbOwAqbFf2e9Ox45bc2Xz3c4D/59ctDKYY0SS3FG
	oqEWc1FxIgABJxvBDAMAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: NeilBrown [mailto:neilb@suse.de]
> Sent: Tuesday, October 23, 2012 12:47 PM
> To: Jaegeuk Kim
> Cc: linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org; gregkh@linuxfoundation.org;
> viro@zeniv.linux.org.uk; arnd@arndb.de; tytso@mit.edu; chur.lee@samsung.com; cm224.lee@samsung.com;
> jooyoung.hwang@samsung.com
> Subject: Re: [PATCH 02/16 v2] f2fs: add on-disk layout
> Importance: High
> 
> On Tue, 23 Oct 2012 11:26:00 +0900 Jaegeuk Kim <jaegeuk.kim@samsung.com>
> wrote:
> 
> > This adds a header file describing the on-disk layout of f2fs.
> >
> 
> 
> > +struct f2fs_inode {
> > +	__le16 i_mode;			/* File mode */
> > +	__u8 i_advise;			/* File hints */
> > +	__u8 i_reserved;		/* Reserved */
> > +	__le32 i_uid;			/* User ID */
> > +	__le32 i_gid;			/* Group ID */
> > +	__le32 i_links;			/* Links count */
> > +	__le64 i_size;			/* File size in bytes */
> > +	__le64 i_blocks;		/* File size in blocks */
> > +	__le64 i_ctime;			/* Inode change time */
> > +	__le64 i_mtime;			/* Modification time */
> > +	__le32 i_ctime_nsec;
> > +	__le32 i_mtime_nsec;
> > +	__le32 current_depth;
> > +	__le32 i_xattr_nid;		/* nid to save xattr */
> > +	__le32 i_flags;			/* file attributes */
> > +	__le32 i_pino;			/* parent inode number */
> > +	__le32 i_namelen;		/* file name length */
> > +	__u8 i_name[F2FS_MAX_NAME_LEN];	/* file name for SPOR */
> > +
> > +	struct f2fs_extent i_ext;	/* caching a largest extent */
> > +
> > +	__le32 i_addr[ADDRS_PER_INODE];	/* Pointers to data blocks */
> > +
> > +	__le32 i_nid[5];		/* direct(2), indirect(2),
> > +						double_indirect(1) node id */
> > +} __packed;
> > +
> 
> 
> You appear to have dropped i_btime - no big deal, you weren't using it anyway.
> However if you ever want to support NFS export you will need some value which
> is assigned when the inode is allocated and never changed until it is
> de-allocated.  This is used to detect when an NFS file-handle refers to a
> previous incarnation of an inode and so should be rejected as STALE.
> i_btime could have possibly provided this, but not any more.  You might want
> to add something back.
> ext3 uses "i_generation" and has an 's_next_generation' in the superblock to
> ensure that each new inode gets a new generation number.

Agreed. I'll check that.

> 
> You've also dropped i_atime.  I can certainly understand the desire to do
> that, but I wonder if it is entirely wise.  There are some use-cases where
> i_mtime is a poor substitute.

Got it.

> 
> Also 'current_depth' looks a little odd without a 'i_' prefix.  It wouldn't
> hurt to have a comment noting that it is for directories.

Agreed.
Thank you for comments. :)

> 
> Thanks,
> NeilBrown


---
Jaegeuk Kim
Samsung


