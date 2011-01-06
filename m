Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802Ab1AFW2a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 17:28:30 -0500
Received: from kroah.org ([198.145.64.141]:55669 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754542Ab1AFWXu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 17:23:50 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Yegor Yefremov <yegor_sub1@visionsystems.de>,
        Yegor Yefremov <yegorslists@googlemail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 20/36] RS485 documentation: add 16C950 UART description
Date: Thu,  6 Jan 2011 14:23:09 -0800
Message-Id: <1294352605-31906-20-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110106215404.GA30624@kroah.com>
References: <20110106215404.GA30624@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yegor Yefremov <yegor_sub1@visionsystems.de>

Add a notion about 16C950 UART, that is using DTR signal for RS485 mode.

Signed-off-by: Yegor Yefremov <yegorslists@googlemail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/serial/serial-rs485.txt |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/Documentation/serial/serial-rs485.txt b/Documentation/serial/serial-rs485.txt
index a3b1af7..a493238 100644
--- a/Documentation/serial/serial-rs485.txt
+++ b/Documentation/serial/serial-rs485.txt
@@ -11,10 +11,11 @@
 
 2. HARDWARE-RELATED CONSIDERATIONS
 
-   Some CPUs (e.g., Atmel AT91) contain a built-in half-duplex mode capable of
-   automatically controlling line direction by toggling RTS. That can used to
-   control external half-duplex hardware like an RS485 transceiver or any
-   RS232-connected half-duplex device like some modems.
+   Some CPUs/UARTs (e.g., Atmel AT91 or 16C950 UART) contain a built-in
+   half-duplex mode capable of automatically controlling line direction by
+   toggling RTS or DTR signals. That can be used to control external
+   half-duplex hardware like an RS485 transceiver or any RS232-connected
+   half-duplex devices like some modems.
 
    For these microcontrollers, the Linux driver should be made capable of
    working in both modes, and proper ioctls (see later) should be made
-- 
1.7.3.2

