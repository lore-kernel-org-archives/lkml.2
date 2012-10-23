Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932341Ab2JWHq3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 03:46:29 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:45664 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756794Ab2JWHq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 03:46:27 -0400
X-AuditID: cbfee61b-b7f616d00000319b-65-50864b52d7e0
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
To: "'Marco Stornelli'" <marco.stornelli@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, viro@zeniv.linux.org.uk, arnd@arndb.de,
        tytso@mit.edu, chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com
References: <001001cdb0c5$2ac96520$805c2f60$%kim@samsung.com>
 <001b01cdb0c6$67e386b0$37aa9410$%kim@samsung.com>
 <CANGUGtC+g22+ohn-QjK+ZQkeoZCk6gsDUn8S=c8jmkJ1tek1AQ@mail.gmail.com>
In-reply-to: <CANGUGtC+g22+ohn-QjK+ZQkeoZCk6gsDUn8S=c8jmkJ1tek1AQ@mail.gmail.com>
Subject: RE: [PATCH 11/16 v2] f2fs: add inode operations for special inodes
Date: Tue, 23 Oct 2012 16:46:25 +0900
Message-id: <009c01cdb0f2$812b5f90$83821eb0$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2w7Ef6hE2j7cl9TuWb9PZrx5FIjwABd33A
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsVy+t8zI90g77YAg1NfxS327D3JYnF51xw2
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDKO333AVnBOuuLpr6nMDYwXhLsYOTgkBEwkGu7qdzFy
	ApliEhfurWfrYuTiEBJYxijRt/YDI0TCROL175fsEIlFjBJXdp1lhHD+MUoc2NfIAjKJTUBb
	YvN+A5AGEQFDiXUnlzGB1DALPGSUmHPzBFT3DkaJb5P3soBUcQoESyy/28cGYgsLeEvc/L8M
	zGYRUJV4Mf8q2GpeAVuJCSfnskLYghI/Jt8DW8YsoCdx/6IWSJhZQF5i85q3zBDfqEs8+qsL
	cYORxP+TZ9kgSkQk9r14xwgxXQDogkMsEOWyEpsOMINcJiGwiV1ib8NaNoiHJSUOrrjBMoFR
	YhaSxbMQFs9CsngWkg0LGFlWMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYoREmPQOxlUNFocY
	BTgYlXh4O/a3BgixJpYVV+YeYpTgYFYS4TW1bwsQ4k1JrKxKLcqPLyrNSS0+xOgDdPhEZinR
	5Hxg9OeVxBsaG5uYmZiamFuampviEFYS5232SAkQEkhPLEnNTk0tSC2CGcfEwSnVwKjKIc/v
	W1Ci9XvdFW2tVXtWVx2q+/YofFp91auY1k/BL6U71u2vDDc81+TUbe4xRVpBh+n8ze1HtIMz
	rsul7t1oeuz9B9v7Gq1qlk/n8m93c0xUZXBKvprA9OH2xE7nxMrovTETKlaWbBWbs+diinG2
	geQ96VC7HYYJa4zYT5w8NjusecPpfCWW4oxEQy3mouJEAM328WHdAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFIsWRmVeSWpSXmKPExsVy+t9jAd0g77YAg3/ThSz27D3JYnF51xw2
	ByaPz5vkAhijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwC
	dN0yc4BGKymUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgzjt99wFZwTrri
	6a+pzA2MF4S7GDk5JARMJF7/fskOYYtJXLi3nq2LkYtDSGARo8SVXWcZIZx/jBIH9jWydDFy
	cLAJaEts3m8A0iAiYCix7uQyJpAaZoGHjBJzbp5gh2jYwSjxbfJeFpAqToFgieV3+9hAbGEB
	b4mb/5eB2SwCqhIv5l9lBLF5BWwlJpycywphC0r8mHwPbBmzgJ7E/YtaIGFmAXmJzWveMoOE
	JQTUJR791YW4wUji/8mzbBAlIhL7XrxjnMAoNAvJoFkIg2YhGTQLSccCRpZVjKKpBckFxUnp
	uUZ6xYm5xaV56XrJ+bmbGMER/Ex6B+OqBotDjAIcjEo8vB37WwOEWBPLiitzDzFKcDArifCa
	2rcFCPGmJFZWpRblxxeV5qQWH2L0AXpzIrOUaHI+MLnklcQbGpuYGVkamVkYmZib4xBWEudt
	9kgJEBJITyxJzU5NLUgtghnHxMEp1cCYpvDyd/vfW2sPn+V2EXG9znfsTtvJDg5TXp4LPMdN
	dn9L5ejuW3fciO94RJjx48uxTGUvH5928myctfBHqrTIO5GJvhk5Sh6x+w10OU0XX13OE534
	4sCTdNmHaWJ3m9x6t6Z/5ZQxEZisu7rq0s2TD6c9+V924erm2zPYz92c03zI3cTWJuuOEktx
	RqKhFnNRcSIAq1dtgA0DAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -----Original Message-----
> From: Marco Stornelli [mailto:marco.stornelli@gmail.com]
> Sent: Tuesday, October 23, 2012 4:02 PM
> To: Jaegeuk Kim
> Cc: linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org; gregkh@linuxfoundation.org;
> viro@zeniv.linux.org.uk; arnd@arndb.de; tytso@mit.edu; chur.lee@samsung.com; cm224.lee@samsung.com;
> jooyoung.hwang@samsung.com
> Subject: Re: [PATCH 11/16 v2] f2fs: add inode operations for special inodes
> Importance: High
> 
> 2012/10/23 Jaegeuk Kim <jaegeuk.kim@samsung.com>:
> > This adds inode operations for directory, symlink, and special inodes.
> >
> > Signed-off-by: Changman Lee <cm224.lee@samsung.com>
> > Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
> > ---
> >  fs/f2fs/namei.c |  494 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 494 insertions(+)
> >  create mode 100644 fs/f2fs/namei.c
> >
> > diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
> > new file mode 100644
> > index 0000000..899d144
> > --- /dev/null
> > +++ b/fs/f2fs/namei.c
> > @@ -0,0 +1,494 @@
> > +/**
> > + * fs/f2fs/namei.c
> > + *
> > + * Copyright (c) 2012 Samsung Electronics Co., Ltd.
> > + *             http://www.samsung.com/
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + */
> > +#include <linux/fs.h>
> > +#include <linux/f2fs_fs.h>
> > +#include <linux/pagemap.h>
> > +#include <linux/sched.h>
> > +#include <linux/ctype.h>
> > +
> > +#include "f2fs.h"
> > +#include "xattr.h"
> > +#include "acl.h"
> > +
> > +static struct inode *f2fs_new_inode(struct inode *dir, umode_t mode)
> > +{
> > +       struct super_block *sb = dir->i_sb;
> > +       struct f2fs_sb_info *sbi = F2FS_SB(sb);
> > +       nid_t ino;
> > +       struct inode *inode;
> > +       bool nid_free = false;
> > +       int err;
> > +
> > +       inode = new_inode(sb);
> > +       if (!inode)
> > +               return ERR_PTR(-ENOMEM);
> > +
> > +       mutex_lock_op(sbi, NODE_NEW);
> > +       if (!alloc_nid(sbi, &ino)) {
> > +               mutex_unlock_op(sbi, NODE_NEW);
> > +               err = -ENOSPC;
> > +               goto fail;
> > +       }
> > +       mutex_unlock_op(sbi, NODE_NEW);
> > +
> > +       inode->i_uid = current_fsuid();
> > +
> > +       if (dir->i_mode & S_ISGID) {
> > +               inode->i_gid = dir->i_gid;
> > +               if (S_ISDIR(mode))
> > +                       mode |= S_ISGID;
> > +       } else {
> > +               inode->i_gid = current_fsgid();
> > +       }
> > +
> > +       inode->i_ino = ino;
> > +       inode->i_mode = mode;
> > +       inode->i_blocks = 0;
> > +       inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
> > +
> > +       err = insert_inode_locked(inode);
> > +       if (err) {
> > +               err = -EINVAL;
> > +               nid_free = true;
> > +               goto out;
> > +       }
> > +
> > +       mark_inode_dirty(inode);
> > +       return inode;
> > +
> > +out:
> > +       clear_nlink(inode);
> > +       unlock_new_inode(inode);
> > +fail:
> > +       iput(inode);
> 
> make_bad_inode here?

I wanted to call f2fs_evict_inode() at this moment.
- f2fs_evict_inode()
 - remove_inode_page()
   -> check any erroneous conditions.

Got coffee? :)

> 
> Marco


---
Jaegeuk Kim
Samsung


