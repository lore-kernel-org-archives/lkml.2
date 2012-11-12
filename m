Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751768Ab2KLGEQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 01:04:16 -0500
Received: from oproxy11-pub.bluehost.com ([173.254.64.10]:33513 "HELO
	oproxy11-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750851Ab2KLGEP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 01:04:15 -0500
Message-ID: <1352700243.2555.11.camel@slavad-ubuntu>
Subject: Re: [PATCH 00/16 v3] f2fs: introduce flash-friendly file system
From: Vyacheslav Dubeyko <slava@dubeyko.com>
To: Jaegeuk Kim <jaegeuk.kim@gmail.com>
Cc: Martin Steigerwald <Martin@lichtvoll.de>, linux-kernel@vger.kernel.org,
        Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        gregkh@linuxfoundation.org, viro@zeniv.linux.org.uk, arnd@arndb.de,
        tytso@mit.edu, chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com
Date: Mon, 12 Nov 2012 10:04:03 +0400
In-Reply-To: <1352634168.1893.9.camel@kjgkr>
References: <003d01cdb74b$0c3fa420$24beec60$%kim@samsung.com>
	 <201211021439.02797.Martin@lichtvoll.de>
	 <CAOtxgye-sqJFe17EyfJQ0RrMwQqsPbDv5m+4cJT0BjnRnGv56w@mail.gmail.com>
	 (sfid-20121105_204523_384093_CECB414C) <201211101933.38434.Martin@lichtvoll.de>
	 <8A3372F6-6294-404E-909B-3FDE0C2368B7@dubeyko.com>
	 <1352634168.1893.9.camel@kjgkr>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0
X-Identified-User: {2172:host202.hostmonster.com:dubeykoc:dubeyko.com} {sentby:smtp auth 178.177.135.204 authed with slava@dubeyko.com}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-11-11 at 20:42 +0900, Jaegeuk Kim wrote:
> 2012-11-11 (일), 00:55 +0300, Vyacheslav Dubeyko:
> > Hi,
> > 
> > On Nov 10, 2012, at 9:33 PM, Martin Steigerwald wrote:
> > 
> > [snip]
> > > 
> > > merkaba:~> mkfs.f2fs /dev/sdb1
> > > Info: sector size = 512
> > > Info: total sectors = 4093951 (in 512bytes)
> > > Info: zone aligned segment0 blkaddr: 256
> > > Info: This device doesn't support TRIM
> > > Info: format successful
> > > merkaba:~> mount /dev/sdb1 /mnt/zeit
> > > mount: you must specify the filesystem type
> > > merkaba:~#32> mount -t f2fs /dev/sdb1 /mnt/zeit
> > > merkaba:~> df -hT /mnt/zeit
> > > Dateisystem    Typ  Größe Benutzt Verf. Verw% Eingehängt auf
> > > /dev/sdb1      f2fs  2,0G    147M  1,8G    8% /mnt/zeit
> > > 
> > 
> > Do you really have trouble with f2fs mount without definition of filesystem type? If so, it is a bug.
> 
> Could you explain this bug in more detail?
> Or, can anyone comment this?
> 
> Actually, I've looking at the *mount* in linux-utils.
> I suspect something does not support f2fs in linux-utils.
> 

Does this issue reproducible or not on last version of f2fs utilities?
There are some probability that it can be an issue of previous version.

As I can understand, if Linux kernel has support of concrete file system
then it should be mounted as with file system type definition as without
it. From my point of understanding, the linux-utils has some
universality and support of all possible file system than kernel can
support. Or I misunderstand something? I think that it can be an issue
on the kernel side. It needs to analyze system log in the case of issue
reproducibility, I think.

With the best regards,
Vyacheslav Dubeyko.

> > 
> > Moreover, I think that it is really inconvenient that mkfs.f2fs doesn't output its version. I suggest to output version of f2fs utilities.
> 
> Agreed.
> But, I'd like to note that f2fs is not merged yet.
> IMHO, it'd better give an initial version after f2fs is merged.
> Thanks,
> 
> > 
> > With the best regards,
> > Vyacheslav Dubeyko.
> > 
> 


