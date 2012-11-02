Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762442Ab2KBNjM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 09:39:12 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:35429 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300Ab2KBNjF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 09:39:05 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/16 v3] f2fs: introduce flash-friendly file system
Date: Fri, 2 Nov 2012 14:39:02 +0100
User-Agent: KMail/1.13.7 (Linux/3.6.0-tp520; KDE/4.8.4; x86_64; ; )
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        gregkh@linuxfoundation.org, viro@zeniv.linux.org.uk, arnd@arndb.de,
        tytso@mit.edu, chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com
References: <003d01cdb74b$0c3fa420$24beec60$%kim@samsung.com> (sfid-20121031_185403_072544_FB971BEB)
In-Reply-To: <003d01cdb74b$0c3fa420$24beec60$%kim@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201211021439.02797.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 31. Oktober 2012 schrieb Jaegeuk Kim:
> Change log from v2:
> 
>  o Fix compilation error for arm [Max]
>  o Move proc entries to debugfs [Greg]
>  o Add i_atime, i_generation, etc [Neil]
>  o Support NFS export [Changman]
>  o Move the f2fs magic number [Marco]
>  o Add s_time_gran [Marco]
>  o Fix f2fs_truncate [Marco]
>  o Enhance f2fs document [Vyacheslav]
>  o Support uuid and add additional comments [Vyacheslav]
>  o Change superblock offset [Vyacheslav]
>  o Fix some bugs and return values [Vyacheslav]
>  o Improve initial mount time [Jaegeuk]
>  o Fix f2fs-tools environment [Mike]
> 
> I've set up a git tree in sf.net for f2fs-tools.
> Please download f2fs-tools by tag: for_patch_set_v3.

I like to try this out.

Do you have kernel code available in some git repo? I didn´t find anything 
on git.kernel.org? Otherwise I take the patches from your mails.

Tools cloned nicely.

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
