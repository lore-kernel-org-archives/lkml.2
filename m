Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684Ab2JWHJk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 03:09:40 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:31969 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756477Ab2JWHJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 03:09:37 -0400
X-AuditID: cbfee61a-b7fa66d0000004cf-c3-508642b04ac2
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
To: "'Marco Stornelli'" <marco.stornelli@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, viro@zeniv.linux.org.uk, arnd@arndb.de,
        tytso@mit.edu, chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com
References: <001001cdb0c5$2ac96520$805c2f60$%kim@samsung.com>
 <001401cdb0c5$e9a7da30$bcf78e90$%kim@samsung.com>
 <CANGUGtCoC80Z4rj7T_qrdyK8WcW2oOxm46mkorUs5abrUKLcsQ@mail.gmail.com>
In-reply-to: <CANGUGtCoC80Z4rj7T_qrdyK8WcW2oOxm46mkorUs5abrUKLcsQ@mail.gmail.com>
Subject: RE: [PATCH 04/16 v2] f2fs: add super block operations
Date: Tue, 23 Oct 2012 16:09:35 +0900
Message-id: <009501cdb0ed$5be1e100$13a5a300$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2w6tLabxpzntQGSbeTbNewfU4lMgAAnPNQ
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsVy+t8zI90NTm0BBud2ylvs2XuSxeLyrjls
	DkwenzfJBTBGcdmkpOZklqUW6dslcGVcff2euWAGU0Xbso/MDYw7GbsYOTkkBEwkZlw4xgRh
	i0lcuLeerYuRi0NIYBmjxNqru1hhivY/vckCkVjEKPFozQJmCOcfo8Tn/0uBRnFwsAloS2ze
	bwDSICJgKLHu5DImkBpmgYeMEnNunmCHaNjBKLH54iF2kCpOgWCJS2+/sYDYwgJ2Ei/OXmIG
	sVkEVCVef1zKBmLzCthK9O89xg5hC0r8mHyPBWQZs4CexP2LWiBhZgF5ic1r3jKDhCUE1CUe
	/dUFMUUEjCQ2nCiHqBCR2PfiHSPEcAGJb5MPsUBUy0psOgD2iYTAJnaJXccmQP0rKXFwxQ2W
	CYwSs5DsnYWwdxaSvbOQbFjAyLKKUTS1ILmgOCk911CvODG3uDQvXS85P3cTIyTCpHYwrmyw
	OMQowMGoxMNrcaQ1QIg1say4MvcQowQHs5IIr6l9W4AQb0piZVVqUX58UWlOavEhRh+gwycy
	S4km5wOjP68k3tDY2MTMxNTE3NLU3BSHsJI4b7NHSoCQQHpiSWp2ampBahHMOCYOTqkGRt1c
	3yTfzf4B92zlCt//ORWlHuJdV6Cwd7K7roZZfURJ+94Y3/iF997EHtU9Fbtg3SrWe1v+/pdW
	43u2j4/1yTs1sx4dXQ3HfWeuc6dP/FUkW7h28/6fObuObSlL0jvw6PqZJ34Mhbfttn/09K8t
	FZVLndwIDO1LK4xeWUkU7LD/tmvHY4taJZbijERDLeai4kQAXnCZA90CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJIsWRmVeSWpSXmKPExsVy+t9jAd0NTm0BBofuy1js2XuSxeLyrjls
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmXH39nrlgBlNF
	27KPzA2MOxm7GDk5JARMJPY/vckCYYtJXLi3nq2LkYtDSGARo8SjNQuYIZx/jBKf/y8F6uDg
	YBPQlti83wCkQUTAUGLdyWVMIDXMAg8ZJebcPMEO0bCDUWLzxUPsIFWcAsESl95+A1shLGAn
	8eLsJWYQm0VAVeL1x6VsIDavgK1E/95j7BC2oMSPyfdYQJYxC+hJ3L+oBRJmFpCX2LzmLTNI
	WEJAXeLRX10QU0TASGLDiXKIChGJfS/eMU5gFJqFZM4shDmzkMyZhaRjASPLKkbR1ILkguKk
	9FxDveLE3OLSvHS95PzcTYzg+H0mtYNxZYPFIUYBDkYlHl6LI60BQqyJZcWVuYcYJTiYlUR4
	Te3bAoR4UxIrq1KL8uOLSnNSiw8x+gB9OZFZSjQ5H5ha8kriDY1NzIwsjcwsjEzMzXEIK4nz
	NnukBAgJpCeWpGanphakFsGMY+LglGpgnCviN/XJx4dtV+ff2P720qLFM07+uW51RzC+oa7R
	7Ej+/a6U9Kbwh+kae6fO8pXfxer4tD5njuizC/zCfzlKGLeUn2Vk77vAcn630NYF8y6Jd6co
	BrouLzxsHNV+5pHhUaVN6t0Hrz8+Pm0my6zwr032Z9nkvq0w2FXV5dGzuqytKG+C44ayMiWW
	4oxEQy3mouJEAPrWJdYMAwAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[snip]

> > +       sb->s_op = &f2fs_sops;
> > +       sb->s_xattr = f2fs_xattr_handlers;
> > +       sb->s_magic = F2FS_SUPER_MAGIC;
> > +       sb->s_fs_info = sbi;
> 
> and s_time_gran?

Ok, I'll check this.
Thanks,

> 
> Marco


---
Jaegeuk Kim
Samsung


