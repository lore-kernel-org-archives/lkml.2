Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301Ab2EAVfI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 17:35:08 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:48497 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163Ab2EAVfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 17:35:05 -0400
Message-ID: <4FA056A1.1040209@us.ibm.com>
Date: Tue, 01 May 2012 14:33:21 -0700
From: John Stultz <johnstul@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Keshava Munegowda <keshava_mgowda@ti.com>
CC: Felipe Balbi <balbi@ti.com>, Samuel Ortiz <sameo@linux.intel.com>,
        lkml <linux-kernel@vger.kernel.org>, "Bergmann, Arnd" <arnd@arndb.de>
Subject: omap-usb-host.c compile error
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12050121-5518-0000-0000-000004103FF9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I've been seeing the following compile issue for a few -rcs now:
drivers/mfd/omap-usb-host.c: In function 'omap_usbhs_init':
drivers/mfd/omap-usb-host.c:524: error: implicit declaration of function 
'cpu_is_omap3430'
drivers/mfd/omap-usb-host.c:524: error: implicit declaration of function 
'omap_rev'
drivers/mfd/omap-usb-host.c:524: error: 'OMAP3430_REV_ES2_1' undeclared 
(first use in this function)
drivers/mfd/omap-usb-host.c:524: error: (Each undeclared identifier is 
reported only once
drivers/mfd/omap-usb-host.c:524: error: for each function it appears in.)

Reverting 1fcb57d0f6e1150003d222051aaaf4bc4a9ccc94 seems to resolve it.

This still isn't fixed in Linus' HEAD. Any plans here?

thanks
-john

