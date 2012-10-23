Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932640Ab2JWI4q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 04:56:46 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:22058 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932238Ab2JWI4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 04:56:41 -0400
X-AuditID: cbfee61b-b7f616d00000319b-d4-50865a00f96c
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
To: "'Marco Stornelli'" <marco.stornelli@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, viro@zeniv.linux.org.uk, arnd@arndb.de,
        tytso@mit.edu, chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com
References: <001001cdb0c5$2ac96520$805c2f60$%kim@samsung.com>
 <001b01cdb0c6$67e386b0$37aa9410$%kim@samsung.com>
 <CANGUGtC+g22+ohn-QjK+ZQkeoZCk6gsDUn8S=c8jmkJ1tek1AQ@mail.gmail.com>
 <009c01cdb0f2$812b5f90$83821eb0$%kim@samsung.com>
 <CANGUGtBtgmWW1VjMP5mEK9qOzLxLUSgD_KvUr1b0+Yi3bHgVBQ@mail.gmail.com>
In-reply-to: <CANGUGtBtgmWW1VjMP5mEK9qOzLxLUSgD_KvUr1b0+Yi3bHgVBQ@mail.gmail.com>
Subject: RE: [PATCH 11/16 v2] f2fs: add inode operations for special inodes
Date: Tue, 23 Oct 2012 17:49:03 +0900
Message-id: <00a201cdb0fb$412efa10$c38cee30$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2w909zfR8vyqA9T+mywiveaLp+mQAAN8QQ
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsVy+t8zQ12GqLYAg389ShZ79p5ksbi8aw6b
	A5PH501yAYxRXDYpqTmZZalF+nYJXBl/J/5kLViiVHHh/i+2BsZTEl2MnBwSAiYSlydNY4aw
	xSQu3FvP1sXIxSEksIxR4vfiNawwRXPW3WADsYUEFjFKLD+UB1H0j1Fi6orNQN0cHGwC2hKb
	9xuA1IgIGEqsO7mMCaSGWeAho8ScmyfYIRo2M0mcXbEKbBKnQLDErs9LwWxhAW+Jm/+Xgdks
	AqoSu85dAjuJV8BW4sv0DhYIW1Dix+R7LCDLmAX0JO5f1AIJMwvIS2xe8xbsBgkBdYlHf3Uh
	bjCSWD7zHjNEiYjEvhfvGCGmC0h8m3yIBaJcVmLTAWaQyyQE1rFLTN9/hQ3iX0mJgytusExg
	lJiFZPEshMWzkCyehWTDAkaWVYyiqQXJBcVJ6blGesWJucWleel6yfm5mxghESa9g3FVg8Uh
	RgEORiUe3o79rQFCrIllxZW5hxglOJiVRHhN7dsChHhTEiurUovy44tKc1KLDzH6AB0+kVlK
	NDkfGP15JfGGxsYmZiamJuaWpuamOISVxHmbPVIChATSE0tSs1NTC1KLYMYxcXBKNTDWcYgm
	XklRqKpcbhzHFvKjcoP+P7G2ssfX5YzeaJl/TbDx1+79++Pf9VkLIt00V/S9k2T8OsX8ZMMS
	d+0TDTrR0vr/j0sLCGy7u2TDnqbf2sEfj5Q/tbX9adrbZbDg2fqyGZdtV/4TCfgTq2f4dOW5
	hKSLJ5zivLbolFpun1VdU+5uwezXdlaJpTgj0VCLuag4EQA0cMJt3QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJIsWRmVeSWpSXmKPExsVy+t9jAV2GqLYAg5XNshZ79p5ksbi8aw6b
	A5PH501yAYxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4B
	um6ZOUCjlRTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGEdYwZfyf+ZC1YolRx
	4f4vtgbGUxJdjJwcEgImEnPW3WCDsMUkLtxbD2YLCSxilFh+KK+LkQvI/scoMXXFZuYuRg4O
	NgFtic37DUBqRAQMJdadXMYEUsMs8JBRYs7NE+wQDZuZJM6uWAU2iVMgWGLX56VgtrCAt8TN
	/8vAbBYBVYld5y4xg9i8ArYSX6Z3sEDYghI/Jt9jAVnGLKAncf+iFkiYWUBeYvOat2A3SAio
	Szz6qwtxg5HE8pn3mCFKRCT2vXjHOIFRaBaSQbMQBs1CMmgWko4FjCyrGEVTC5ILipPSc430
	ihNzi0vz0vWS83M3MYLj95n0DsZVDRaHGAU4GJV4eDv2twYIsSaWFVfmHmKU4GBWEuE1tW8L
	EOJNSaysSi3Kjy8qzUktPsToA/TmRGYp0eR8YGrJK4k3NDYxM7I0MrMwMjE3xyGsJM7b7JES
	ICSQnliSmp2aWpBaBDOOiYNTqoGxL/Tw7+pNR86t3XLs2nTpqRt33lS9/HS1w+KjM+WtrdXv
	xghUJL1dXN1xNC52w3n3v2d+ht7ZpOWx8Z9D4JOgHfPuch/7ZTtbimPddj/Ndwatxz663Ek2
	58g7wy8TFmT2Z2+xV++fueqhsiGV2pd1mplKTXYJLfhpOMmipeNgxj2z7wyPrixIVmIpzkg0
	1GIuKk4EAMSxkQAMAwAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 2012/10/23 Jaegeuk Kim <jaegeuk.kim@samsung.com>:
> >
> >> -----Original Message-----
> >> From: Marco Stornelli [mailto:marco.stornelli@gmail.com]
> >> Sent: Tuesday, October 23, 2012 4:02 PM
> >> To: Jaegeuk Kim
> >> Cc: linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org; gregkh@linuxfoundation.org;
> >> viro@zeniv.linux.org.uk; arnd@arndb.de; tytso@mit.edu; chur.lee@samsung.com; cm224.lee@samsung.com;
> >> jooyoung.hwang@samsung.com
> >> Subject: Re: [PATCH 11/16 v2] f2fs: add inode operations for special inodes
> >> Importance: High
> >>
> >> 2012/10/23 Jaegeuk Kim <jaegeuk.kim@samsung.com>:
> >> > This adds inode operations for directory, symlink, and special inodes.
> >> >
> >> > Signed-off-by: Changman Lee <cm224.lee@samsung.com>
> >> > Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
> >> > ---
> >> >  fs/f2fs/namei.c |  494 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >> >  1 file changed, 494 insertions(+)
> >> >  create mode 100644 fs/f2fs/namei.c
> >> >
> >> > diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
> >> > new file mode 100644
> >> > index 0000000..899d144
> >> > --- /dev/null
> >> > +++ b/fs/f2fs/namei.c
> >> > @@ -0,0 +1,494 @@
> >> > +/**
> >> > + * fs/f2fs/namei.c
> >> > + *
> >> > + * Copyright (c) 2012 Samsung Electronics Co., Ltd.
> >> > + *             http://www.samsung.com/
> >> > + *
> >> > + * This program is free software; you can redistribute it and/or modify
> >> > + * it under the terms of the GNU General Public License version 2 as
> >> > + * published by the Free Software Foundation.
> >> > + */
> >> > +#include <linux/fs.h>
> >> > +#include <linux/f2fs_fs.h>
> >> > +#include <linux/pagemap.h>
> >> > +#include <linux/sched.h>
> >> > +#include <linux/ctype.h>
> >> > +
> >> > +#include "f2fs.h"
> >> > +#include "xattr.h"
> >> > +#include "acl.h"
> >> > +
> >> > +static struct inode *f2fs_new_inode(struct inode *dir, umode_t mode)
> >> > +{
> >> > +       struct super_block *sb = dir->i_sb;
> >> > +       struct f2fs_sb_info *sbi = F2FS_SB(sb);
> >> > +       nid_t ino;
> >> > +       struct inode *inode;
> >> > +       bool nid_free = false;
> >> > +       int err;
> >> > +
> >> > +       inode = new_inode(sb);
> >> > +       if (!inode)
> >> > +               return ERR_PTR(-ENOMEM);
> >> > +
> >> > +       mutex_lock_op(sbi, NODE_NEW);
> >> > +       if (!alloc_nid(sbi, &ino)) {
> >> > +               mutex_unlock_op(sbi, NODE_NEW);
> >> > +               err = -ENOSPC;
> >> > +               goto fail;
> >> > +       }
> >> > +       mutex_unlock_op(sbi, NODE_NEW);
> >> > +
> >> > +       inode->i_uid = current_fsuid();
> >> > +
> >> > +       if (dir->i_mode & S_ISGID) {
> >> > +               inode->i_gid = dir->i_gid;
> >> > +               if (S_ISDIR(mode))
> >> > +                       mode |= S_ISGID;
> >> > +       } else {
> >> > +               inode->i_gid = current_fsgid();
> >> > +       }
> >> > +
> >> > +       inode->i_ino = ino;
> >> > +       inode->i_mode = mode;
> >> > +       inode->i_blocks = 0;
> >> > +       inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
> >> > +
> >> > +       err = insert_inode_locked(inode);
> >> > +       if (err) {
> >> > +               err = -EINVAL;
> >> > +               nid_free = true;
> >> > +               goto out;
> >> > +       }
> >> > +
> >> > +       mark_inode_dirty(inode);
> >> > +       return inode;
> >> > +
> >> > +out:
> >> > +       clear_nlink(inode);
> >> > +       unlock_new_inode(inode);
> >> > +fail:
> >> > +       iput(inode);
> >>
> >> make_bad_inode here?
> >
> > I wanted to call f2fs_evict_inode() at this moment.
> > - f2fs_evict_inode()
> >  - remove_inode_page()
> >    -> check any erroneous conditions.
> >
> > Got coffee? :)
> >
> 
> Not yet, I'm reading my 240 email yet :)
> I meant not to replace iput but to add make_bad_inode() before (I
> don't know if it was clear). I don't know if it's the right thing to
> do. In case of "out" I'd do the "rollback" here.
> 

Sorry, I confused what you said. I need a cup of coffee.
IMHO, it seems there is no difference, since f2fs doesn't allow
a race condition on inodes with a same inode number.
(e.g., one is bad, and the other is newly allocated with the same
inode number.)

> Marco

