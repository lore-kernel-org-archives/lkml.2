Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759897Ab2KBWtP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 18:49:15 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:51673 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754663Ab2KBWtM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 18:49:12 -0400
MIME-Version: 1.0
In-Reply-To: <201211021439.02797.Martin@lichtvoll.de>
References: <003d01cdb74b$0c3fa420$24beec60$%kim@samsung.com>
	<201211021439.02797.Martin@lichtvoll.de>
Date: Sat, 3 Nov 2012 07:49:11 +0900
Message-ID: <CAOtxgye-sqJFe17EyfJQ0RrMwQqsPbDv5m+4cJT0BjnRnGv56w@mail.gmail.com>
Subject: Re: [PATCH 00/16 v3] f2fs: introduce flash-friendly file system
From: Kim Jaegeuk <jaegeuk.kim@gmail.com>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-kernel@vger.kernel.org, Jaegeuk Kim <jaegeuk.kim@samsung.com>,
        linux-fsdevel@vger.kernel.org, gregkh@linuxfoundation.org,
        viro@zeniv.linux.org.uk, arnd@arndb.de, tytso@mit.edu,
        chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/11/2 Martin Steigerwald <Martin@lichtvoll.de>
>
> Am Mittwoch, 31. Oktober 2012 schrieb Jaegeuk Kim:
> > Change log from v2:
> >
> >  o Fix compilation error for arm [Max]
> >  o Move proc entries to debugfs [Greg]
> >  o Add i_atime, i_generation, etc [Neil]
> >  o Support NFS export [Changman]
> >  o Move the f2fs magic number [Marco]
> >  o Add s_time_gran [Marco]
> >  o Fix f2fs_truncate [Marco]
> >  o Enhance f2fs document [Vyacheslav]
> >  o Support uuid and add additional comments [Vyacheslav]
> >  o Change superblock offset [Vyacheslav]
> >  o Fix some bugs and return values [Vyacheslav]
> >  o Improve initial mount time [Jaegeuk]
> >  o Fix f2fs-tools environment [Mike]
> >
> > I've set up a git tree in sf.net for f2fs-tools.
> > Please download f2fs-tools by tag: for_patch_set_v3.
>
> I like to try this out.
>
> Do you have kernel code available in some git repo? I didn´t find anything
> on git.kernel.org? Otherwise I take the patches from your mails.
>

At this moment, there is no f2fs-repo yet in public.
If f2fs is merged, I'd like to make a dev tree somewhere.
I really want to make the dev tree in kernel.org later, but it totally depends
on the maintainers' decision.
Before then, I apologize to retrieve f2fs sources from LKML.
Thanks,

--
Jaegeuk Kim
Samsung

> Tools cloned nicely.
>
> Thanks,
> --
> Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
> GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
