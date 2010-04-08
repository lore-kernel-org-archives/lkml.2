Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933075Ab0DHSRP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 14:17:15 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:46874 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933012Ab0DHSRO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 14:17:14 -0400
From: pavan_savoy@ti.com
To: gregkh@suse.de, alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org, npelly@google.com, pavan_savoy@yahoo.co.in
Subject: New ldisc for WiLink7.0
Date: Thu,  8 Apr 2010 13:16:51 -0500
Message-Id: <1270750619-19174-1-git-send-email-pavan_savoy@ti.com>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Most of the patches have been re-worked.
Removed un-wanted and un-used global references.
Removed the creation of global kobject @ root (from previous version)

<from previous edition>
Texas Instruments has introduced it's new series of WiLink chipsets which has Bluetooth, WLAN, FM-Rx and FM-Tx and GPS on 1 single chip.
This series of chipsets allow apps processor to interface with the chip over a single UART mux-ed for all 3 (BT,FM and GPS) cores on chip and SDIO for WLAN.

The following list of patches introduces a new line discipline which allows such muxing to happen, and 3 different BT, FM and GPS drivers would sit on top of this driver (registering/unregistering) and glue this to relevant s/w stacks.

This has been verified to work on TI's OMAP platforms(34xx,36xx and 44xx).

