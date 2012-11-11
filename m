Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648Ab2KKLnB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 06:43:01 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:43337 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244Ab2KKLm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 06:42:59 -0500
Message-ID: <1352634168.1893.9.camel@kjgkr>
Subject: Re: [PATCH 00/16 v3] f2fs: introduce flash-friendly file system
From: Jaegeuk Kim <jaegeuk.kim@gmail.com>
To: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Martin Steigerwald <Martin@lichtvoll.de>, linux-kernel@vger.kernel.org,
        Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        gregkh@linuxfoundation.org, viro@zeniv.linux.org.uk, arnd@arndb.de,
        tytso@mit.edu, chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com
Date: Sun, 11 Nov 2012 20:42:48 +0900
In-Reply-To: <8A3372F6-6294-404E-909B-3FDE0C2368B7@dubeyko.com>
References: <003d01cdb74b$0c3fa420$24beec60$%kim@samsung.com>
	 <201211021439.02797.Martin@lichtvoll.de>
	 <CAOtxgye-sqJFe17EyfJQ0RrMwQqsPbDv5m+4cJT0BjnRnGv56w@mail.gmail.com>
	 (sfid-20121105_204523_384093_CECB414C) <201211101933.38434.Martin@lichtvoll.de>
	 <8A3372F6-6294-404E-909B-3FDE0C2368B7@dubeyko.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012-11-11 (일), 00:55 +0300, Vyacheslav Dubeyko:
> Hi,
> 
> On Nov 10, 2012, at 9:33 PM, Martin Steigerwald wrote:
> 
> [snip]
> > 
> > merkaba:~> mkfs.f2fs /dev/sdb1
> > Info: sector size = 512
> > Info: total sectors = 4093951 (in 512bytes)
> > Info: zone aligned segment0 blkaddr: 256
> > Info: This device doesn't support TRIM
> > Info: format successful
> > merkaba:~> mount /dev/sdb1 /mnt/zeit
> > mount: you must specify the filesystem type
> > merkaba:~#32> mount -t f2fs /dev/sdb1 /mnt/zeit
> > merkaba:~> df -hT /mnt/zeit
> > Dateisystem    Typ  Größe Benutzt Verf. Verw% Eingehängt auf
> > /dev/sdb1      f2fs  2,0G    147M  1,8G    8% /mnt/zeit
> > 
> 
> Do you really have trouble with f2fs mount without definition of filesystem type? If so, it is a bug.

Could you explain this bug in more detail?
Or, can anyone comment this?

Actually, I've looking at the *mount* in linux-utils.
I suspect something does not support f2fs in linux-utils.

> 
> Moreover, I think that it is really inconvenient that mkfs.f2fs doesn't output its version. I suggest to output version of f2fs utilities.

Agreed.
But, I'd like to note that f2fs is not merged yet.
IMHO, it'd better give an initial version after f2fs is merged.
Thanks,

> 
> With the best regards,
> Vyacheslav Dubeyko.
> 

-- 
Jaegeuk Kim
Samsung

