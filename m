Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281Ab1DZMy4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 08:54:56 -0400
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:48139 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755112Ab1DZMyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 08:54:55 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEABTAtk1R8BPE/2dsb2JhbAClR3jESQ6FaAScYw
Date: Tue, 26 Apr 2011 14:54:53 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Seth Heasley <seth.heasley@intel.com>
Subject: [GIT PULL REQUEST] watchdog - v2.6.39-rc4
Message-ID: <20110426125452.GD17580@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'master' branch of
	git://git.kernel.org/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
or if master.kernel.org hasn't synced up yet:
	master.kernel.org:/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git

This will update the following files:

 drivers/watchdog/iTCO_wdt.c |   97 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 97 insertions(+)

with these Changes:

Author: Seth Heasley <seth.heasley@intel.com>
Date:   Wed Apr 20 10:56:20 2011 -0700

    watchdog: iTCO_wdt: TCO Watchdog patch for Intel Panther Point PCH
    
    This patch adds the TCO Watchdog DeviceIDs for the Intel Panther Point PCH.
    
    Signed-off-by: Seth Heasley <seth.heasley@intel.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

The Changes can also be looked at on:
	http://www.kernel.org/git/?p=linux/kernel/git/wim/linux-2.6-watchdog.git;a=summary

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/drivers/watchdog/iTCO_wdt.c b/drivers/watchdog/iTCO_wdt.c
index 35a0d12..5fd020d 100644
--- a/drivers/watchdog/iTCO_wdt.c
+++ b/drivers/watchdog/iTCO_wdt.c
@@ -35,6 +35,7 @@
  *	document number 324645-001, 324646-001: Cougar Point (CPT)
  *	document number TBD                   : Patsburg (PBG)
  *	document number TBD                   : DH89xxCC
+ *	document number TBD                   : Panther Point
  */
 
 /*
@@ -153,6 +154,38 @@ enum iTCO_chipsets {
 	TCO_PBG1,	/* Patsburg */
 	TCO_PBG2,	/* Patsburg */
 	TCO_DH89XXCC,	/* DH89xxCC */
+	TCO_PPT0,	/* Panther Point */
+	TCO_PPT1,	/* Panther Point */
+	TCO_PPT2,	/* Panther Point */
+	TCO_PPT3,	/* Panther Point */
+	TCO_PPT4,	/* Panther Point */
+	TCO_PPT5,	/* Panther Point */
+	TCO_PPT6,	/* Panther Point */
+	TCO_PPT7,	/* Panther Point */
+	TCO_PPT8,	/* Panther Point */
+	TCO_PPT9,	/* Panther Point */
+	TCO_PPT10,	/* Panther Point */
+	TCO_PPT11,	/* Panther Point */
+	TCO_PPT12,	/* Panther Point */
+	TCO_PPT13,	/* Panther Point */
+	TCO_PPT14,	/* Panther Point */
+	TCO_PPT15,	/* Panther Point */
+	TCO_PPT16,	/* Panther Point */
+	TCO_PPT17,	/* Panther Point */
+	TCO_PPT18,	/* Panther Point */
+	TCO_PPT19,	/* Panther Point */
+	TCO_PPT20,	/* Panther Point */
+	TCO_PPT21,	/* Panther Point */
+	TCO_PPT22,	/* Panther Point */
+	TCO_PPT23,	/* Panther Point */
+	TCO_PPT24,	/* Panther Point */
+	TCO_PPT25,	/* Panther Point */
+	TCO_PPT26,	/* Panther Point */
+	TCO_PPT27,	/* Panther Point */
+	TCO_PPT28,	/* Panther Point */
+	TCO_PPT29,	/* Panther Point */
+	TCO_PPT30,	/* Panther Point */
+	TCO_PPT31,	/* Panther Point */
 };
 
 static struct {
@@ -244,6 +277,38 @@ static struct {
 	{"Patsburg", 2},
 	{"Patsburg", 2},
 	{"DH89xxCC", 2},
+	{"Panther Point", 2},
+	{"Panther Point", 2},
+	{"Panther Point", 2},
+	{"Panther Point", 2},
+	{"Panther Point", 2},
+	{"Panther Point", 2},
+	{"Panther Point", 2},
+	{"Panther Point", 2},
+	{"Panther Point", 2},
+	{"Panther Point", 2},
+	{"Panther Point", 2},
+	{"Panther Point", 2},
+	{"Panther Point", 2},
+	{"Panther Point", 2},
+	{"Panther Point", 2},
+	{"Panther Point", 2},
+	{"Panther Point", 2},
+	{"Panther Point", 2},
+	{"Panther Point", 2},
+	{"Panther Point", 2},
+	{"Panther Point", 2},
+	{"Panther Point", 2},
+	{"Panther Point", 2},
+	{"Panther Point", 2},
+	{"Panther Point", 2},
+	{"Panther Point", 2},
+	{"Panther Point", 2},
+	{"Panther Point", 2},
+	{"Panther Point", 2},
+	{"Panther Point", 2},
+	{"Panther Point", 2},
+	{"Panther Point", 2},
 	{NULL, 0}
 };
 
@@ -363,6 +428,38 @@ static DEFINE_PCI_DEVICE_TABLE(iTCO_wdt_pci_tbl) = {
 	{ ITCO_PCI_DEVICE(0x1d40,				TCO_PBG1)},
 	{ ITCO_PCI_DEVICE(0x1d41,				TCO_PBG2)},
 	{ ITCO_PCI_DEVICE(0x2310,				TCO_DH89XXCC)},
+	{ ITCO_PCI_DEVICE(0x1e40,				TCO_PPT0)},
+	{ ITCO_PCI_DEVICE(0x1e41,				TCO_PPT1)},
+	{ ITCO_PCI_DEVICE(0x1e42,				TCO_PPT2)},
+	{ ITCO_PCI_DEVICE(0x1e43,				TCO_PPT3)},
+	{ ITCO_PCI_DEVICE(0x1e44,				TCO_PPT4)},
+	{ ITCO_PCI_DEVICE(0x1e45,				TCO_PPT5)},
+	{ ITCO_PCI_DEVICE(0x1e46,				TCO_PPT6)},
+	{ ITCO_PCI_DEVICE(0x1e47,				TCO_PPT7)},
+	{ ITCO_PCI_DEVICE(0x1e48,				TCO_PPT8)},
+	{ ITCO_PCI_DEVICE(0x1e49,				TCO_PPT9)},
+	{ ITCO_PCI_DEVICE(0x1e4a,				TCO_PPT10)},
+	{ ITCO_PCI_DEVICE(0x1e4b,				TCO_PPT11)},
+	{ ITCO_PCI_DEVICE(0x1e4c,				TCO_PPT12)},
+	{ ITCO_PCI_DEVICE(0x1e4d,				TCO_PPT13)},
+	{ ITCO_PCI_DEVICE(0x1e4e,				TCO_PPT14)},
+	{ ITCO_PCI_DEVICE(0x1e4f,				TCO_PPT15)},
+	{ ITCO_PCI_DEVICE(0x1e50,				TCO_PPT16)},
+	{ ITCO_PCI_DEVICE(0x1e51,				TCO_PPT17)},
+	{ ITCO_PCI_DEVICE(0x1e52,				TCO_PPT18)},
+	{ ITCO_PCI_DEVICE(0x1e53,				TCO_PPT19)},
+	{ ITCO_PCI_DEVICE(0x1e54,				TCO_PPT20)},
+	{ ITCO_PCI_DEVICE(0x1e55,				TCO_PPT21)},
+	{ ITCO_PCI_DEVICE(0x1e56,				TCO_PPT22)},
+	{ ITCO_PCI_DEVICE(0x1e57,				TCO_PPT23)},
+	{ ITCO_PCI_DEVICE(0x1e58,				TCO_PPT24)},
+	{ ITCO_PCI_DEVICE(0x1e59,				TCO_PPT25)},
+	{ ITCO_PCI_DEVICE(0x1e5a,				TCO_PPT26)},
+	{ ITCO_PCI_DEVICE(0x1e5b,				TCO_PPT27)},
+	{ ITCO_PCI_DEVICE(0x1e5c,				TCO_PPT28)},
+	{ ITCO_PCI_DEVICE(0x1e5d,				TCO_PPT29)},
+	{ ITCO_PCI_DEVICE(0x1e5e,				TCO_PPT30)},
+	{ ITCO_PCI_DEVICE(0x1e5f,				TCO_PPT31)},
 	{ 0, },			/* End of list */
 };
 MODULE_DEVICE_TABLE(pci, iTCO_wdt_pci_tbl);
