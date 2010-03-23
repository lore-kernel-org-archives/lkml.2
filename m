Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468Ab0CWUmv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 16:42:51 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:52758 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753615Ab0CWUla (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 16:41:30 -0400
From: pavan_savoy@ti.com
To: gregkh@suse.de, alan@lxorguk.ukuu.org.uk
Cc: pavan_savoy@ti.com, linux-kernel@vger.kernel.org, pavan_savoy@yahoo.co.in
Subject: [v3] New ldisc for WiLink7.0
Date: Tue, 23 Mar 2010 15:41:08 -0500
Message-Id: <1269376875-25940-1-git-send-email-pavan_savoy@ti.com>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Greg / Alan,

Moved to staging directory as suggested.
All the patches have been modified to now go into drivers/staging/

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
