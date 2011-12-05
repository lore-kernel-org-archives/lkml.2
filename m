Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932221Ab1LEM5w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 07:57:52 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:35955 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932133Ab1LEM5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 07:57:50 -0500
MIME-Version: 1.0
In-Reply-To: <CALJfu6Nf8Ns4Tyfu5VgJgMJ66HQ5Pk2p+xsSe3oY=LqvHySmhQ@mail.gmail.com>
References: <CANudz+vcq7NaBGB=HZkgEwArDga+CH-LAfJ4Bm236a-Sjs-5Wg@mail.gmail.com>
	<CAGdaadZaCY8cLKEN8he1=gytFo30od+nMYJ2yP3YTDcTbP2fwg@mail.gmail.com>
	<CALJfu6Nf8Ns4Tyfu5VgJgMJ66HQ5Pk2p+xsSe3oY=LqvHySmhQ@mail.gmail.com>
Date: Mon, 5 Dec 2011 18:27:49 +0530
Message-ID: <CAC+QLdSa_FsRr-2GO17+OpTvYFF-oKLAquEvBS_yW950RGFoqA@mail.gmail.com>
Subject: Re: What is Backing device used for?
From: Mandeep Sandhu <mandeepsandhu.chd@gmail.com>
To: rohan puri <rohan.puri15@gmail.com>
Cc: Mulyadi Santosa <mulyadi.santosa@gmail.com>,
        kernelnewbies@kernelnewbies.org, LKML <linux-kernel@vger.kernel.org>,
        loody <miloody@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> > Is there any document which explain what "backing device" used for?

Have a look at the initramfs doc to get brief idea:
http://www.mjmwired.net/kernel/Documentation/filesystems/ramfs-rootfs-initramfs.txt

>From what I've understood, is that backing device/store is the device
onto which _committed_ data is actually written. This might be a block
device like a hard-disk, flash mem or even the RAM (used by in-memory
file-systems).

CMIIW.

HTH,
-mandeep
