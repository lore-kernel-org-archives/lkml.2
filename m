Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758437Ab0FBP1p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 11:27:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39198 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757905Ab0FBP1o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 11:27:44 -0400
Date: Wed, 2 Jun 2010 11:27:22 -0400
From: John Villalovos <jvillalo@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH] Documentation: Add doc about aerdriver.* parameters to
 kernel-parameters.txt
Message-ID: <20100602152721.GA8939@linuxjohn.usersys.redhat.com>
Reply-To: John Villalovos <jvillalo@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding documentation about two aerdriver.* command line parameters.

Signed-off-by: John L. Villalovos <john.l.villalovos@intel.com>

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 1808f11..57ff168 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -293,6 +293,19 @@ and is between 256 and 4096 characters. It is defined in the file
 			Format: <io>,<irq>,<dma>,<mss_io>,<mpu_io>,<mpu_irq>
 			See also header of sound/oss/aedsp16.c.
 
+	aerdriver.forceload= [HW,PCIE] Advanced Error Recovery (AER) Root Driver
+			{ y, n }
+			y: Force the AER Root driver to load
+			n: Do not force the AER Root driver to load [DEFAULT]
+			See also Documentation/PCI/pcieaer-howto.txt
+
+	aerdriver.nosourceid= [HW,PCIE]
+			{ y, n }
+			y: Use when broken hardware (mostly chipsets) has root
+			   ports that cannot obtain the reporting source ID.
+			n: [DEFAULT]
+			See also Documentation/PCI/pcieaer-howto.txt
+
 	agp=		[AGP]
 			{ off | try_unsupported }
 			off: disable AGP support
