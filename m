Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280Ab0JOKIk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 06:08:40 -0400
Received: from smtp.nokia.com ([192.100.122.233]:64080 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754461Ab0JOKIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 06:08:39 -0400
Subject: Re: Difference between twl4030_hsmmc_info and
 omap_mmc_platform_data
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Elvis Dowson <elvis.dowson@mac.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>
In-Reply-To: <DB759C09-975B-4088-B334-79F9010573F8@mac.com>
References: <DB759C09-975B-4088-B334-79F9010573F8@mac.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Oct 2010 13:08:13 +0300
Message-ID: <1287137293.8979.13.camel@capsicum>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Oct 2010 10:08:17.0374 (UTC) FILETIME=[E31D8FE0:01CB6C50]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Elvis,

On Thu, 2010-10-14 at 23:48 +0200, ext Elvis Dowson wrote:
>        I'm trying to bring up a TI WL1271 wlan module connected to MMC2 controller of a TI OMAP 3530 processor. 

Some weeks ago I have sent a patch to linux-omap and linux-wireless
mailing lists to add support for the wl1271 expansion card on the Beagle
board.  It was not accepted because of two things: first I had hardcoded
the board configuration file, so that it would only work with wl1271
(and not with other expansion boards); second the expansion card should
be detected by using the EEPROM connected to the i2c lines in the
expansion board, but at the moment Beagle people do this kind of
detection in the bootloader and not in the kernel

Anyways, the patch I sent works at least with the wl1271 daugther card
from CircuitCo, if you just want to try it out.

https://patchwork.kernel.org/patch/201572/


-- 
Cheers,
Luca.

