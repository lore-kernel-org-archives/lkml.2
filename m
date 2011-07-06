Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103Ab1GFPcS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 11:32:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41787 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753910Ab1GFPcR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 11:32:17 -0400
Message-ID: <4E147FFA.1020902@redhat.com>
Date: Wed, 06 Jul 2011 12:32:10 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL for v3.1-rc7] media fixes
References: <4E14775D.9010503@redhat.com>
In-Reply-To: <4E14775D.9010503@redhat.com>
X-Enigmail-Version: 1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 06-07-2011 11:55, Mauro Carvalho Chehab escreveu:
> Hi Linus,
> 
> Please pull from:
>   ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git v4l_for_linus
> 
> For a series of bug fixes:
> 	- mx1-camera were using an uninitialized variable;
> 	- pwc issues at USB disconnect;
> 	- several mceusb and lirc fixes;
> 	- some OOPSes fixes at uvc driver;
> 	- some videobuf2 fixes;
> 	- some omap1 camera fixes;
> 	- m5mols/s5p-fimc fixes (this is a driver added at 3.0 merge window);
> 
> Thanks!
> Mauro
> 

Linus,

In time:
 
There will be a small conflict when applying over 3.0-rc6:

$ git diff
diff --cc MAINTAINERS
index ae563fa,63be58b..0000000
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@@ -6733,6 -6723,7 +6733,10 @@@ F:     fs/fat
  VIDEOBUF2 FRAMEWORK
  M:    Pawel Osciak <pawel@osciak.com>
  M:    Marek Szyprowski <m.szyprowski@samsung.com>
++<<<<<<< HEAD
++=======
+ M:        Kyungmin Park <kyungmin.park@samsung.com>
++>>>>>>> 98c32bcded0e249fd48726930ae9f393e0e318b4
  L:    linux-media@vger.kernel.org
  S:    Maintained
  F:    drivers/media/video/videobuf2-*

The right conflict resolution is to add Kyugmin's name as one of the VB2
maintainers.

Thanks,
Mauro
