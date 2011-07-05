Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752307Ab1GERzQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 13:55:16 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:44513 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473Ab1GERzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 13:55:14 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 1/2] gma500: Update the TODO list
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Tue, 05 Jul 2011 18:45:28 +0100
Message-ID: <20110705174527.28250.53338.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

This is now horribly out of date

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/TODO |   29 +++++++++--------------------
 1 files changed, 9 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/gma500/TODO b/drivers/staging/gma500/TODO
index f692ce1..fc83615 100644
--- a/drivers/staging/gma500/TODO
+++ b/drivers/staging/gma500/TODO
@@ -1,26 +1,15 @@
--	Test on more platforms
--	Clean up the various chunks of unused code
 -	Sort out the power management side. Not important for Poulsbo but
-	matters for Moorestown
--	Add Moorestown support (single pipe, no BIOS, no stolen memory,
-				some other differences)
--	Sort out the bo and ttm code to support userframe buffers and DRM
-	interfaces rather than just faking it enough for a framebuffer
+	matters for Moorestown/Medfield
+-	Debug Oaktrail/Moorestown support (single pipe, no BIOS on mrst,
+					some other differences)
 -	Add 2D acceleration via console and DRM
+-	Add scrolling acceleration using the GTT to do remapping on the main
+	framebuffer.
+-	HDMI testing
+-	Oaktrail HDMI and other features
+-	Oaktrail MIPI
+-	Medfield needs a lot of further love
 
 As per kernel policy and the in the interest of the safety of various
 kittens there is no support or plans to add hooks for the closed user space
 stuff.
-
-
-Why bother ?
-- Proper display configuration
-- Can be made to work on Moorestown where VESA won't
-- Works on systems where the VESA BIOS is bust or the tables are broken
-  without hacks
-- 2D acceleration
-
-Currently tested on
-+	Dell Mini 10 100x600
-
-

