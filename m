Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017Ab0CYXUj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 19:20:39 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:50446 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751679Ab0CYXUi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 19:20:38 -0400
From: pavan_savoy@ti.com
To: marcel@holtmann.org, gregkh@suse.de, alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org, pavan_savoy@yahoo.co.in
Subject: [v4] New ldisc for WiLink7.0
Date: Thu, 25 Mar 2010 18:20:15 -0500
Message-Id: <1269559223-4043-1-git-send-email-pavan_savoy@ti.com>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Greg / Alan,


- moved to staging and completely self-contained
- REMOVed the sysfs entry creation at root and replaced it with
sending events via rfkill.
- verified and working with new logic
- patch re-ordered

Note:
Sorry for being annoying (some call it being persistent)

>Moved to staging directory as suggested.
>All the patches have been modified to now go into drivers/staging/

> Texas Instruments has introduced it's new series of WiLink chipsets
> which has Bluetooth, WLAN, FM-Rx and FM-Tx and GPS on 1 single chip.
> This series of chipsets allow apps processor to interface with the chip
> over a single UART mux-ed for all 3 (BT,FM and GPS) cores on chip and
> SDIO for WLAN.
> 
> The following list of patches introduces a new line discipline which allows 
> such muxing to happen, and 3 different BT, FM and GPS drivers would sit on
> top of this driver (registering/unregistering) and glue this to relevant s/w
> stacks.
> 
> This has been verified to work on TI's OMAP platforms(34xx,36xx and 44xx).

