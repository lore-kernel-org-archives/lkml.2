Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521Ab2GQHTy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 03:19:54 -0400
Received: from 115-188-14-127.jetstream.xtra.co.nz ([115.188.14.127]:64392
	"EHLO SERVER.prisktech.co.nz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753772Ab2GQHTw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 03:19:52 -0400
X-Greylist: delayed 323 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Jul 2012 03:19:52 EDT
From: Tony Prisk <linux@prisktech.co.nz>
To: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
CC: Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        "vt8500-wm8505-linux-kernel@googlegroups.com" 
	<vt8500-wm8505-linux-kernel@googlegroups.com>
Subject: [PATCH 1/1] Add Wondermedia Technologies (wmt) to
 docs/devicetree/vendor-bindings.txt
Thread-Topic: [PATCH 1/1] Add Wondermedia Technologies (wmt) to
 docs/devicetree/vendor-bindings.txt
Thread-Index: Ac1j60YjC8Ir3nj9THS9B3oTgHAVgQ==
Date: Tue, 17 Jul 2012 07:11:38 +0000
Message-ID: <76F764B079F92A4E843589C893D0A022C380F1D4@SERVER.prisktech.co.nz>
Accept-Language: en-NZ, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 756ae5c2f475d679649adff99058679b651af8d9 Mon Sep 17 00:00:00 2001
From: Tony Prisk <linux@prisktech.co.nz>
Date: Tue, 17 Jul 2012 19:09:31 +1200
Subject: [PATCH] Add Wondermedia Technologies (wmt) to vendor-prefixes.txt
 Signed-off-by: Tony Prisk <linux@prisktech.co.nz>

---
 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index db4d3af..b87dc6b 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -48,4 +48,5 @@ st	STMicroelectronics
 stericsson	ST-Ericsson
 ti	Texas Instruments
 wlf	Wolfson Microelectronics
+wmt	Wondermedia Technologies
 xlnx	Xilinx
-- 
1.7.2.5
