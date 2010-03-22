Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756351Ab0CVVTa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 17:19:30 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:47861 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756361Ab0CVVT2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 17:19:28 -0400
From: pavan_savoy@ti.com
To: gregkh@suse.de
Cc: alan@lxorguk.ukuu.org.uk, pavan_savoy@ti.com, linux-kernel@vger.kernel.org
Subject: [re-worked] New ldisc for WiLink7.0
Date: Mon, 22 Mar 2010 16:19:10 -0500
Message-Id: <1269292756-7469-1-git-send-email-pavan_savoy@ti.com>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Greg/Alan & the linux-kernel community,

Texas Instruments has introduced it's new series of WiLink chipsets
which has Bluetooth, WLAN, FM-Rx and FM-Tx and GPS on 1 single chip.
This series of chipsets allow apps processor to interface with the chip
over a single UART mux-ed for all 3 (BT,FM and GPS) cores on chip and
SDIO for WLAN.

The following list of patches introduces a new line discipline which allows
such muxing to happen, and 3 different BT, FM and GPS drivers would sit on
top of this driver (registering/unregistering) and glue this to relevant s/w
stacks.

This has been verified to work on TI's OMAP platforms(34xx,36xx and 44xx).
