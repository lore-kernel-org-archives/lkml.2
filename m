Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861Ab1CARui (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 12:50:38 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:54216 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753542Ab1CARug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 12:50:36 -0500
Date: Tue, 1 Mar 2011 09:50:26 -0800
From: Gary Hade <garyhade@us.ibm.com>
To: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: "Darrick J. Wong" <djwong@us.ibm.com>, Krzysztof Helt <krzysztof.h1@wp.pl>,
        Petr Vandrovec <vandrove@vc.cvut.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Gary Hade <garyhade@us.ibm.com>
Subject: matroxfb: remove incorrect Matrox G200eV support
Message-ID: <20110301175026.GA18770@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Gary Hade <garyhade@us.ibm.com>

Remove incorrect Matrox G200eV support that was previously added
by commit e3a1938805d2e81b27d3d348788644f3bad004f2

One serious issue with the G200eV support that I have reproduced
on a Matrox G200eV equipped IBM x3650 M2 is the lack of text (login
banner, login prompt, etc) on the console when X not running and
lack of text on all of the virtual consoles after X is started.

Signed-off-by: Gary Hade <garyhade@us.ibm.com>
Cc: Darrick J. Wong <djwong@us.ibm.com>
Cc: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Petr Vandrovec <vandrove@vc.cvut.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>

---
 drivers/video/matrox/matroxfb_base.c |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/drivers/video/matrox/matroxfb_base.c b/drivers/video/matrox/matroxfb_base.c
index a082deb..a74439a 100644
--- a/drivers/video/matrox/matroxfb_base.c
+++ b/drivers/video/matrox/matroxfb_base.c
@@ -1461,13 +1461,6 @@ static struct board {
 		MGA_G100,
 		&vbG100,
 		"MGA-G100 (AGP)"},
-	{PCI_VENDOR_ID_MATROX,	PCI_DEVICE_ID_MATROX_G200EV_PCI,	0xFF,
-		0,			0,
-		DEVF_G200,
-		230000,
-		MGA_G200,
-		&vbG200,
-		"MGA-G200eV (PCI)"},
 	{PCI_VENDOR_ID_MATROX,	PCI_DEVICE_ID_MATROX_G200_PCI,	0xFF,
 		0,			0,
 		DEVF_G200,
@@ -2119,8 +2112,6 @@ static struct pci_device_id matroxfb_devices[] = {
 		PCI_ANY_ID,	PCI_ANY_ID,	0, 0, 0},
 	{PCI_VENDOR_ID_MATROX,	PCI_DEVICE_ID_MATROX_G100_AGP,
 		PCI_ANY_ID,	PCI_ANY_ID,	0, 0, 0},
-	{PCI_VENDOR_ID_MATROX,	PCI_DEVICE_ID_MATROX_G200EV_PCI,
-		PCI_ANY_ID,	PCI_ANY_ID,	0, 0, 0},
 	{PCI_VENDOR_ID_MATROX,	PCI_DEVICE_ID_MATROX_G200_PCI,
 		PCI_ANY_ID,	PCI_ANY_ID,	0, 0, 0},
 	{PCI_VENDOR_ID_MATROX,	PCI_DEVICE_ID_MATROX_G200_AGP,
