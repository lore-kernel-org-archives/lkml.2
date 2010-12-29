Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751914Ab0L2Ks4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 05:48:56 -0500
Received: from mail.wdtv.com ([66.118.69.84]:59173 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750962Ab0L2Ksz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 05:48:55 -0500
From: Gene Heskett <gene.heskett@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: re: linux-2.6.37-rc8
Date: Wed, 29 Dec 2010 05:48:52 -0500
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc8; KDE/4.5.4; i686; ; )
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201012290548.52110.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings all;

I finally got vesa running, and it appears I don't have any functioning 
serial comm ports, like /dev/ttyS0, and bluez won't run so /dev/rfcomm0 is 
also dead, as in not created.

Suggestions please, these serial ports are heavily used here.  And they 
worked flawlessly with 2.6.36.1 + Mike G's patches.  Make oldconfig was 
based on that 2.6.36.1 .config

Thanks.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
I used to be Snow White, but I drifted.
		-- Mae West
