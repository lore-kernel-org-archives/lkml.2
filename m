Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910Ab0LXUgw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 15:36:52 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:38708 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752330Ab0LXUgu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 15:36:50 -0500
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1956BAcCgN5OCYL39Sxe9jXdkUCvQOx4GuHETXcAP
	3lzqVRRnDvUX1p
Message-ID: <4D15045C.90909@gmx.de>
Date: Fri, 24 Dec 2010 21:36:44 +0100
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100328)
MIME-Version: 1.0
To: BruceChang@via.com.tw
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        BenjaminPan@viatech.com
Subject: Re: [PATCH] MAINTAINERS: update entries affecting VIA Technologies
 (resent as plaintext with hopefully all broken formatting fixed; merry Christmas)
References: <88652C7DDEB86A45A61D4100C612CD731E8CFB@exchtp12.taipei.via.com.tw>
In-Reply-To: <88652C7DDEB86A45A61D4100C612CD731E8CFB@exchtp12.taipei.via.com.tw>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bruce Chang <BruceChang@via.com.tw>
Date: Fri, 17 Dec 2010 21:05:57 +0800
Subject: [PATCH] MAINTAINERS: update entries affecting VIA Technologies

Since the original maintainer-Joseph Chan (josephchan@via.com.tw)
doesn't handle the Linux driver for VIA now, I would like to request to
update the maintainer for the SD/MMC CARD CONTROLLER DRIVER and VIA
UNICHROME(PRO)/CHROME9 FRAMEBUFFER DRIVER before we find a better one.
Thank you very much for help.

Sign-off by: Bruce Chang < brucechang@via.com.tw >

--- linux-b4-modified/MAINTAINERS       2010-12-16 09:24:48.000000000 +0800
+++ linux-aftr-modified/MAINTAINERS     2010-12-17 16:50:00.793647029 +0800
@@ -6384,13 +6384,12 @@
  F:	drivers/i2c/busses/i2c-viapro.c

  VIA SD/MMC CARD CONTROLLER DRIVER
-M:	Joseph Chan <JosephChan@via.com.tw>
+M:	Bruce Chang <brucechang@via.com.tw>
  M:	Harald Welte <HaraldWelte@viatech.com>
  S:	Maintained
  F:	drivers/mmc/host/via-sdmmc.c

  VIA UNICHROME(PRO)/CHROME9 FRAMEBUFFER DRIVER
-M:	Joseph Chan <JosephChan@via.com.tw>
  M:	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
  L:	linux-fbdev@vger.kernel.org
  S:	Maintained
