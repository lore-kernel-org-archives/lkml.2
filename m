Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668Ab2JWHIo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 03:08:44 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:31797 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756136Ab2JWHIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 03:08:42 -0400
X-AuditID: cbfee61a-b7fa66d0000004cf-d0-508642792af1
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
To: "'Marco Stornelli'" <marco.stornelli@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, viro@zeniv.linux.org.uk, arnd@arndb.de,
        tytso@mit.edu, chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com
References: <001001cdb0c5$2ac96520$805c2f60$%kim@samsung.com>
 <001201cdb0c5$bdf728f0$39e57ad0$%kim@samsung.com>
 <CANGUGtDLAQxjiRgFDhJww1j7qSEshvJbHFKaD_QwmjyK9rBBmQ@mail.gmail.com>
In-reply-to: <CANGUGtDLAQxjiRgFDhJww1j7qSEshvJbHFKaD_QwmjyK9rBBmQ@mail.gmail.com>
Subject: RE: [PATCH 02/16 v2] f2fs: add on-disk layout
Date: Tue, 23 Oct 2012 16:08:40 +0900
Message-id: <009401cdb0ed$3af5afd0$b0e10f70$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2w6kFrxBSM1rDUQoiNrnGnlVhslwAAev7w
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsVy+t8zI91Kp7YAgzNv2Cz27D3JYnF51xw2
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDKmnzrMWrCdu+L6kVNsDYyfOboYOTkkBEwk5n3cwwxh
	i0lcuLeerYuRi0NIYBmjxOZHmxhhin7+mMAKkVjEKLFq2SRmCOcfo0T3rP3sXYwcHGwC2hKb
	9xuANIgIGEqsO7mMCaSGWeAho8ScmyfYIRp2MEr0/1vEBFLFKRAssW7ZOjBbWMBMou/tQ3YQ
	m0VAVaLpyVywOK+ArcSus9cZIWxBiR+T77GALGMW0JO4f1ELJMwsIC+xec1bZpCwhIC6xKO/
	uhA3GEmc/buVBaJERGLfi3eMENMFJL5NPsQCUS4rsekA2CsSApvYJV6eeskG8bCkxMEVN1gm
	MErMQrJ4FsLiWUgWz0KyYQEjyypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2MkBiT2sG4ssHi
	EKMAB6MSD6/FkdYAIdbEsuLK3EOMEhzMSiK8pvZtAUK8KYmVValF+fFFpTmpxYcYfYAOn8gs
	JZqcD4z/vJJ4Q2NjEzMTUxNzS1NzUxzCSuK8zR4pAUIC6YklqdmpqQWpRTDjmDg4pRoYc/2D
	/24yfxT/vGKqQPRJtZnLRJN2NdjMvaLyx7ydxTbyVz7H+Vs6ugGp60K3OnM0vJO8Yr7oYf/R
	Eg2t/dMYzqcE3/I9vc3VUaQrSvrmcRGLDVcKW1TY9TdoXKjx28K75cbNvLQ3j1Y0LfWas2Lu
	rF0tCqqrVfWENkldM211VfGJZmzk2C2uxFKckWioxVxUnAgAqLGF2t4CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFIsWRmVeSWpSXmKPExsVy+t9jAd1Kp7YAg38zmSz27D3JYnF51xw2
	ByaPz5vkAhijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwC
	dN0yc4BGKymUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgzpp86zFqwnbvi
	+pFTbA2Mnzm6GDk5JARMJH7+mMAKYYtJXLi3nq2LkYtDSGARo8SqZZOYIZx/jBLds/azdzFy
	cLAJaEts3m8A0iAiYCix7uQyJpAaZoGHjBJzbp5gh2jYwSjR/28RE0gVp0CwxLpl68BsYQEz
	ib63D9lBbBYBVYmmJ3PB4rwCthK7zl5nhLAFJX5MvscCsoxZQE/i/kUtkDCzgLzE5jVvmUHC
	EgLqEo/+6kLcYCRx9u9WFogSEYl9L94xTmAUmoVk0CyEQbOQDJqFpGMBI8sqRtHUguSC4qT0
	XEO94sTc4tK8dL3k/NxNjOAIfia1g3Flg8UhRgEORiUeXosjrQFCrIllxZW5hxglOJiVRHhN
	7dsChHhTEiurUovy44tKc1KLDzH6AL05kVlKNDkfmFzySuINjU3MjCyNzCyMTMzNcQgrifM2
	e6QECAmkJ5akZqemFqQWwYxj4uCUamCU/bZdeH7yGi9mv+OWvyp/P382OdM4oeS1zL4U7r6d
	acqXdhz/vD7EO/aGRtGqL8rhj8/19DY1beMxcTW77f1Pq1j7g9BRi9mJXllrzh+SZJx/u8JU
	/cqm98e/mlS+n6QV779QJyvl6eE7b2e+VzD2Tv0nMfOfLtvLKVXtbzb8W3j9reSa6T7blFiK
	MxINtZiLihMBqmG08A0DAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 2012/10/23 Jaegeuk Kim <jaegeuk.kim@samsung.com>:
> > This adds a header file describing the on-disk layout of f2fs.
> >
> > Signed-off-by: Changman Lee <cm224.lee@samsung.com>
> > Signed-off-by: Chul Lee <chur.lee@samsung.com>
> > Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
> > ---
> >  include/linux/f2fs_fs.h |  362 +++++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 362 insertions(+)
> >  create mode 100644 include/linux/f2fs_fs.h
> >
> > diff --git a/include/linux/f2fs_fs.h b/include/linux/f2fs_fs.h
> > new file mode 100644
> > index 0000000..bd9c217
> > --- /dev/null
> > +++ b/include/linux/f2fs_fs.h
> > @@ -0,0 +1,362 @@
> > +/**
> > + * include/linux/f2fs_fs.h
> 
> Is this file used by user space?

Currently, no.
But, later, I'll use this file in format and fsck tools.

> 
> > + *
> > + * Copyright (c) 2012 Samsung Electronics Co., Ltd.
> > + *             http://www.samsung.com/
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + */
> > +#ifndef _LINUX_F2FS_FS_H
> > +#define _LINUX_F2FS_FS_H
> > +
> > +#include <linux/pagemap.h>
> > +#include <linux/types.h>
> > +
> > +#define F2FS_SUPER_MAGIC       0xF2F52010
> 
> In magic.h please.

Ok, thank you.

> 
> Marco


---
Jaegeuk Kim
Samsung


