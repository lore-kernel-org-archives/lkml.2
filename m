Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757963Ab1LNX00 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 18:26:26 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:54881 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150Ab1LNX0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 18:26:25 -0500
From: David Daney <ddaney.cavm@gmail.com>
To: devicetree-discuss@lists.ozlabs.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: [PATCH resend] OF/device-tree: Add some entries to vendor-prefixes.txt
Date: Wed, 14 Dec 2011 15:26:19 -0800
Message-Id: <1323905179-28355-1-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

We are currently using 'cavium', 'cortina' and 'st', add them to the
list of known prefixes.

Signed-off-by: David Daney <david.daney@cavium.com>
---
 .../devicetree/bindings/vendor-prefixes.txt        |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index afb9bff..6708797 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -8,7 +8,9 @@ amcc	Applied Micro Circuits Corporation (APM, formally AMCC)
 apm	Applied Micro Circuits Corporation (APM)
 arm	ARM Ltd.
 atmel	Atmel Corporation
+cavium	Cavium, Inc.
 chrp	Common Hardware Reference Platform
+cortina	Cortina Systems, Inc.
 dallas	Maxim Integrated Products (formerly Dallas Semiconductor)
 denx	Denx Software Engineering
 epson	Seiko Epson Corp.
@@ -36,6 +38,7 @@ schindler	Schindler
 sil	Silicon Image
 simtek
 sirf	SiRF Technology, Inc.
+st	STMicroelectronics
 stericsson	ST-Ericsson
 ti	Texas Instruments
 wlf	Wolfson Microelectronics
-- 
1.7.2.3

