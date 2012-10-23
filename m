Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731Ab2JWHbd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 03:31:33 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:36548 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754227Ab2JWHbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 03:31:31 -0400
X-AuditID: cbfee61b-b7f616d00000319b-9c-508647d1fbb6
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
To: "'Marco Stornelli'" <marco.stornelli@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, viro@zeniv.linux.org.uk, arnd@arndb.de,
        tytso@mit.edu, chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com
References: <001001cdb0c5$2ac96520$805c2f60$%kim@samsung.com>
 <001801cdb0c6$35bd6430$a1382c90$%kim@samsung.com>
 <CANGUGtASk=_xd4xz_PXA+ittW2G2Z01DXsRjH67jBgXdpiG82w@mail.gmail.com>
In-reply-to: <CANGUGtASk=_xd4xz_PXA+ittW2G2Z01DXsRjH67jBgXdpiG82w@mail.gmail.com>
Subject: RE: [PATCH 08/16 v2] f2fs: add file operations
Date: Tue, 23 Oct 2012 16:31:29 +0900
Message-id: <009b01cdb0f0$6ad18cd0$4074a670$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2w6+IO7k/5q8poQFaRx7Dshw9s+wAA3Kww
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsVy+t8zfd2L7m0BBteWmFns2XuSxeLyrjls
	DkwenzfJBTBGcdmkpOZklqUW6dslcGW8OTWZrWCBRMXLbfeYGxj383cxcnJICJhIfHxwnAXC
	FpO4cG89WxcjF4eQwDJGieZLN1hhii7f3MwEkVjEKHFi2RtmCOcfo8S86Q1A7RwcbALaEpv3
	G4A0iAgYSqw7uQysgVngIaPEnJsn2CEadjBK7Ln0nR2kilMgWOLuhWlgu4UFzCXO3T3HBGKz
	CKhKnFyylxHE5hWwlfixcC6ULSjxY/I9sGXMAnoS9y9qgYSZBeQlNq95ywwSlhBQl3j0Vxfi
	BiOJhts3mSFKRCT2vXjHCDFdQOLb5EMsEOWyEpsOgL0iIbCJXWLehpeMEA9LShxccYNlAqPE
	LCSLZyEsnoVk8SwkGxYwsqxiFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECIkx6R2MqxosDjEK
	cDAq8fB27G8NEGJNLCuuzD3EKMHBrCTCa2rfFiDEm5JYWZValB9fVJqTWnyI0Qfo8InMUqLJ
	+cD4zyuJNzQ2NjEzMTUxtzQ1N8UhrCTO2+yREiAkkJ5YkpqdmlqQWgQzjomDU6qBcfr/37pn
	7ORDHkbfDLohl+nB/3DJP//G58t3qc3o887c/8jr4c5L3/68ktVYscvg05UVjoIeaXPet5iI
	CFyc/VvQ9Ede2MzA2I2dK1I0J8glyuVzZW/rmfNkw8JsroVfn1lfX7F02XJvFuEZ5/sfr93x
	4darsK7yy1JFP32F2T6KezlP9LygnajEUpyRaKjFXFScCADrwRbC3gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFIsWRmVeSWpSXmKPExsVy+t9jAd2L7m0BBq+fGVrs2XuSxeLyrjls
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmvDk1ma1ggUTF
	y233mBsY9/N3MXJySAiYSFy+uZkJwhaTuHBvPVsXIxeHkMAiRokTy94wQzj/GCXmTW9g6WLk
	4GAT0JbYvN8ApEFEwFBi3cllTCA1zAIPGSXm3DzBDtGwg1Fiz6Xv7CBVnALBEncvTGMBsYUF
	zCXO3T0Hto5FQFXi5JK9jCA2r4CtxI+Fc6FsQYkfk++BLWMW0JO4f1ELJMwsIC+xec1bZpCw
	hIC6xKO/uhA3GEk03L7JDFEiIrHvxTvGCYxCs5AMmoUwaBaSQbOQdCxgZFnFKJpakFxQnJSe
	a6RXnJhbXJqXrpecn7uJERzBz6R3MK5qsDjEKMDBqMTD27G/NUCINbGsuDL3EKMEB7OSCK+p
	fVuAEG9KYmVValF+fFFpTmrxIUYfoDcnMkuJJucDk0teSbyhsYmZkaWRmYWRibk5DmElcd5m
	j5QAIYH0xJLU7NTUgtQimHFMHJxSDYxOSiuS2I1iJx6ZkXzwXv/H5C279m9w+d3+5z9feMJh
	STabr4/SDtf9neA3U93ltzJ/FK/v3cvq2Vs08h095h3JNFsjWl5+5KGsyLmXG6dyJzds+zK7
	79TURFX7WtFYQ/ObraxVixa9WKtvaF88ZU/lvpbr+36YuD5e3tqZaDvJ2PnZm9mH/JYpsRRn
	JBpqMRcVJwIArtG5mA0DAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +void f2fs_truncate(struct inode *inode)
> > +{
> > +       if (!(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
> > +                               S_ISLNK(inode->i_mode)))
> > +               return;
> > +
> > +       if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
> > +               return;
> 
> No truncate for an append only file? You call f2fs_truncate from
> evict_inode, so no block freeing when this kind of inode is deleted.

Agreed.

> 
> > +
> > +       if (!truncate_blocks(inode, i_size_read(inode))) {
> > +               inode->i_mtime = inode->i_ctime = CURRENT_TIME;
> > +               mark_inode_dirty(inode);
> > +       }
> > +
> > +       f2fs_balance_fs(F2FS_SB(inode->i_sb));
> > +}
> > +
> > +static int f2fs_getattr(struct vfsmount *mnt,
> > +                        struct dentry *dentry, struct kstat *stat)
> > +{
> > +       struct inode *inode = dentry->d_inode;
> > +       generic_fillattr(inode, stat);
> > +       stat->blocks <<= 3;
> > +       return 0;
> > +}
> > +
> > +#ifdef CONFIG_F2FS_FS_POSIX_ACL
> > +static void __setattr_copy(struct inode *inode, const struct iattr *attr)
> > +{
> > +       struct f2fs_inode_info *fi = F2FS_I(inode);
> > +       unsigned int ia_valid = attr->ia_valid;
> > +
> > +       if (ia_valid & ATTR_UID)
> > +               inode->i_uid = attr->ia_uid;
> > +       if (ia_valid & ATTR_GID)
> > +               inode->i_gid = attr->ia_gid;
> > +       if (ia_valid & ATTR_ATIME)
> > +               inode->i_atime = timespec_trunc(attr->ia_atime,
> > +                                               inode->i_sb->s_time_gran);
> > +       if (ia_valid & ATTR_MTIME)
> > +               inode->i_mtime = timespec_trunc(attr->ia_mtime,
> > +                                               inode->i_sb->s_time_gran);
> > +       if (ia_valid & ATTR_CTIME)
> > +               inode->i_ctime = timespec_trunc(attr->ia_ctime,
> > +                                               inode->i_sb->s_time_gran);
> > +       if (ia_valid & ATTR_MODE) {
> > +               umode_t mode = attr->ia_mode;
> > +
> > +               if (!in_group_p(inode->i_gid) && !capable(CAP_FSETID))
> > +                       mode &= ~S_ISGID;
> > +               set_acl_inode(fi, mode);
> > +       }
> > +}
> > +#else
> > +#define __setattr_copy setattr_copy
> > +#endif
> > +
> > +int f2fs_setattr(struct dentry *dentry, struct iattr *attr)
> > +{
> > +       struct inode *inode = dentry->d_inode;
> > +       struct f2fs_inode_info *fi = F2FS_I(inode);
> > +       int err;
> > +
> > +       err = inode_change_ok(inode, attr);
> > +       if (err)
> > +               return err;
> > +
> > +       if ((attr->ia_valid & ATTR_SIZE) &&
> > +                       attr->ia_size != i_size_read(inode)) {
> > +               truncate_setsize(inode, attr->ia_size);
> > +               f2fs_truncate(inode);
> 
> No need to call truncate_pagecache & co.?

truncate_setsize() calls truncate_pagecache().
Any comment?

> 
> Marco



---
Jaegeuk Kim
Samsung

