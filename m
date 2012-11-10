Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679Ab2KJUzY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2012 15:55:24 -0500
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:45278 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752451Ab2KJUzW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2012 15:55:22 -0500
Subject: Re: [PATCH 00/16 v3] f2fs: introduce flash-friendly file system
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=iso-8859-1
From: Vyacheslav Dubeyko <slava@dubeyko.com>
In-Reply-To: <201211101933.38434.Martin@lichtvoll.de>
Date: Sun, 11 Nov 2012 00:55:39 +0300
Cc: linux-kernel@vger.kernel.org, Kim Jaegeuk <jaegeuk.kim@gmail.com>,
        Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        gregkh@linuxfoundation.org, viro@zeniv.linux.org.uk, arnd@arndb.de,
        tytso@mit.edu, chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com
Content-Transfer-Encoding: 8BIT
Message-Id: <8A3372F6-6294-404E-909B-3FDE0C2368B7@dubeyko.com>
References: <003d01cdb74b$0c3fa420$24beec60$%kim@samsung.com> <201211021439.02797.Martin@lichtvoll.de> <CAOtxgye-sqJFe17EyfJQ0RrMwQqsPbDv5m+4cJT0BjnRnGv56w@mail.gmail.com> (sfid-20121105_204523_384093_CECB414C) <201211101933.38434.Martin@lichtvoll.de>
To: Martin Steigerwald <Martin@lichtvoll.de>
X-Mailer: Apple Mail (2.1085)
X-Identified-User: {2172:host202.hostmonster.com:dubeykoc:dubeyko.com} {sentby:smtp auth 46.39.244.28 authed with slava@dubeyko.com}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Nov 10, 2012, at 9:33 PM, Martin Steigerwald wrote:

[snip]
> 
> merkaba:~> mkfs.f2fs /dev/sdb1
> Info: sector size = 512
> Info: total sectors = 4093951 (in 512bytes)
> Info: zone aligned segment0 blkaddr: 256
> Info: This device doesn't support TRIM
> Info: format successful
> merkaba:~> mount /dev/sdb1 /mnt/zeit
> mount: you must specify the filesystem type
> merkaba:~#32> mount -t f2fs /dev/sdb1 /mnt/zeit
> merkaba:~> df -hT /mnt/zeit
> Dateisystem    Typ  Größe Benutzt Verf. Verw% Eingehängt auf
> /dev/sdb1      f2fs  2,0G    147M  1,8G    8% /mnt/zeit
> 

Do you really have trouble with f2fs mount without definition of filesystem type? If so, it is a bug.

Moreover, I think that it is really inconvenient that mkfs.f2fs doesn't output its version. I suggest to output version of f2fs utilities.

With the best regards,
Vyacheslav Dubeyko.

