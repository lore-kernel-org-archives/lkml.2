Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085Ab0IAQG7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 12:06:59 -0400
Received: from mail.wdtv.com ([66.118.69.84]:33025 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204Ab0IAQG6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 12:06:58 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Sep 2010 12:06:57 EDT
From: gene heskett <gheskett@wdtv.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: building 2.6.36-rc3, bails out at building modules stage 2
Date: Wed, 1 Sep 2010 12:00:10 -0400
User-Agent: KMail/1.13.5 (Linux/2.6.35.4; KDE/4.5.0; i686; ; )
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201009011200.11264.gheskett@wdtv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings all;

Using my usual build script, I got a bailout at the end:

  Building modules, stage 2.
  MODPOST 869 modules
ERROR: "st_get_plat_device" [drivers/staging/ti-st/st_drv.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2

And I don't recognize that driver, but I don't believe I need it, so I'll 
try to stop the building of it.


Comments?

Thanks.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
It is easier to make a saint out of a libertine than out of a prig.
		-- George Santayana
