Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538Ab2D1IzI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 04:55:08 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:3965 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752231Ab2D1IzF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 04:55:05 -0400
X-Server-Uuid: B730DE51-FC43-4C83-941F-F1F78A914BDD
Message-ID: <4F9BB05E.4020800@broadcom.com>
Date: Sat, 28 Apr 2012 10:54:54 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120411
 Thunderbird/11.0.1
MIME-Version: 1.0
To: "Anatolij Gustschin" <agust@denx.de>
cc: linux-kernel@vger.kernel.org, "Samuel Ortiz" <sameo@linux.intel.com>,
        "Keshava Munegowda" <Keshava_mgowda@ti.com>
Subject: Re: [PATCH] mfd: omap-ush-host: Fix build breakage
References: <1335114510-29413-1-git-send-email-agust@denx.de>
In-Reply-To: <1335114510-29413-1-git-send-email-agust@denx.de>
X-WSS-ID: 63856FEC3E024518126-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2012 07:08 PM, Anatolij Gustschin wrote:
> Commit 1fcb57d0f6e1150003d222051aaaf4bc4a9ccc94 (ARM: OMAP3: USB: Fix
> the EHCI ULPI PHY reset issue) removed #include<linux/gpio.h>  which
> indirectly includes 'plat/cpu.h'. This caused build breakage:
>
> drivers/mfd/omap-usb-host.c: In function 'omap_usbhs_init':
> drivers/mfd/omap-usb-host.c:525:3: error: implicit declaration of function 'cpu_is_omap3430'
> drivers/mfd/omap-usb-host.c:525:3: error: implicit declaration of function 'omap_rev'
> drivers/mfd/omap-usb-host.c:525:43: error: 'OMAP3430_REV_ES2_1' undeclared (first use in this function)
>
> Include<plat/cpu.h>  to fix it.
>
> Signed-off-by: Anatolij Gustschin<agust@denx.de>
> Cc: Keshava Munegowda<Keshava_mgowda@ti.com>

Build failed on OMAP4 Pandaboard as well. Applied the patch and 
successfully built.

Tested-by: Arend van Spriel <arend@broadcom.com>

Gr. AvS


