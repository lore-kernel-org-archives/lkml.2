Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742Ab0GUEvb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 00:51:31 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:58207 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615Ab0GUEvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:51:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=NG1XqM1m10TtMiLXeJa8x9owhvKN260xFlfwpxzCxReHwEGXjNkgAcE/aCAKNczfK9
         SYSMrapyRh4UBeUcdy6ky9lj9cWYm5mRrNtUNU9uHagcrZbQKISbPLPanP+7EdonYRa/
         RSARuTgvq+xFg6tSrx+NJ1eRzFUVUSoSIPfU8=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 4/4]Documentation/arm/IXP4xx update web address.
Date: Tue, 20 Jul 2010 21:50:50 -0700
Message-Id: <1279687861-29282-5-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279687861-29282-1-git-send-email-justinmattock@gmail.com>
References: <1279687861-29282-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below updates some broken web addresses, and
also removes a web address in of which I cannot find.
If anybody knows where this might be let me know, and I'll
resend an updated patch.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/arm/IXP4xx |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/Documentation/arm/IXP4xx b/Documentation/arm/IXP4xx
index 72fbcc4..336675d 100644
--- a/Documentation/arm/IXP4xx
+++ b/Documentation/arm/IXP4xx
@@ -45,7 +45,7 @@ require the use of Intel's propietary CSR softare:
 If you need to use any of the above, you need to download Intel's
 software from:
 
-   http://developer.intel.com/design/network/products/npfamily/ixp425swr1.htm
+   http://developer.intel.com/design/network/products/npfamily/ixp425.htm    
 
 DO NOT POST QUESTIONS TO THE LINUX MAILING LISTS REGARDING THE PROPIETARY
 SOFTWARE.
@@ -53,7 +53,7 @@ SOFTWARE.
 There are several websites that provide directions/pointers on using
 Intel's software:
 
-http://ixp4xx-osdg.sourceforge.net/ 
+   http://sourceforge.net/projects/ixp4xx-osdg/
    Open Source Developer's Guide for using uClinux and the Intel libraries 
 
 http://gatewaymaker.sourceforge.net/ 
@@ -112,21 +112,21 @@ http://www.adiengineering.com/productsCoyote.html
    Finally, there is an IDE port hanging off the expansion bus.
 
 Gateworks Avila Network Platform
-http://www.gateworks.com/avila_sbc.htm
+http://www.gateworks.com/support/overview.php
 
    The Avila platform is basically and IXDP425 with the 4 PCI slots
    replaced with mini-PCI slots and a CF IDE interface hanging off
    the expansion bus.
 
 Intel IXDP425 Development Platform
-http://developer.intel.com/design/network/products/npfamily/ixdp425.htm
+http://www.intel.com/design/network/products/npfamily/ixdpg425.htm  
 
    This is Intel's standard reference platform for the IXDP425 and is 
    also known as the Richfield board. It contains 4 PCI slots, 16MB
    of flash, two 10/100 ports and one ADSL port.
 
 Intel IXDP465 Development Platform
-http://developer.intel.com/design/network/products/npfamily/ixdp465.htm
+http://www.intel.com/design/network/products/npfamily/ixdp465.htm
 
    This is basically an IXDP425 with an IXP465 and 32M of flash instead
    of just 16.
@@ -141,15 +141,13 @@ Intel IXDPG425 Development Platform
    a pivot_root to NFS.
 
 Motorola PrPMC1100 Processor Mezanine Card
-http://www.fountainsys.com/datasheet/PrPMC1100.pdf
+http://www.fountainsys.com
 
    The PrPMC1100 is based on the IXCP1100 and is meant to plug into
    and IXP2400/2800 system to act as the system controller. It simply
    contains a CPU and 16MB of flash on the board and needs to be
    plugged into a carrier board to function. Currently Linux only
    supports the Motorola PrPMC carrier board for this platform.
-   See https://mcg.motorola.com/us/ds/pdf/ds0144.pdf for info
-   on the carrier board.
 
 5. TODO LIST
 
-- 
1.7.1.rc1.21.gf3bd6

