Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756115Ab1EIAXR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 20:23:17 -0400
Received: from mail.wdtv.com ([66.118.69.84]:49861 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754064Ab1EIAXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 20:23:14 -0400
From: Gene Heskett <gene.heskett@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: trying to build 2.6.38.5?
Date: Sun, 8 May 2011 20:23:09 -0400
User-Agent: KMail/1.13.7 (Linux/2.6.38.5-pclos1.pae.bfs; KDE/4.6.3; i686; ; )
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201105082023.09878.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At the end of a make -j2 all:

/home/gene/src/linux-2.6.38.5-gene/include/linux/Kbuild:25: *** commands 
commence before first target.  Stop.
make[2]: *** [linux] Error 2
make[2]: *** Waiting for unfinished jobs....
make[1]: *** [headers_install] Error 2
make: *** [vmlinux] Error 2

What am I missing?

Thanks.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
<http://tinyurl.com/ddg5bz>
<http://www.cantrip.org/gatto.html>
* TwingyAFK is shopping for 17" flat panel
* aav sells TwingyAFK a piece of plywood
