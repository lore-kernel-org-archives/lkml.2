Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730Ab1GBXyQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 19:54:16 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:48173 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151Ab1GBXyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 19:54:11 -0400
From: Chris Forbes <chrisf@ijw.co.nz>
To: Matthieu CASTET <castet.matthieu@free.fr>
Cc: Stanislaw Gruszka <stf_xl@wp.pl>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, Chris Forbes <chrisf@ijw.co.nz>
Subject: [PATCH 2/2] drivers: usb: atm: ueagle-atm: Add missing const qualifier
Date: Sun,  3 Jul 2011 11:53:34 +1200
Message-Id: <1309650814-18929-2-git-send-email-chrisf@ijw.co.nz>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1309650814-18929-1-git-send-email-chrisf@ijw.co.nz>
References: <1309650814-18929-1-git-send-email-chrisf@ijw.co.nz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added missing const qualifier as flagged by checkpatch.pl

Signed-off-by: Chris Forbes <chrisf@ijw.co.nz>
---
 drivers/usb/atm/ueagle-atm.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/atm/ueagle-atm.c b/drivers/usb/atm/ueagle-atm.c
index 2909457..428f368 100644
--- a/drivers/usb/atm/ueagle-atm.c
+++ b/drivers/usb/atm/ueagle-atm.c
@@ -535,8 +535,8 @@ struct intr_pkt {
 
 static struct usb_driver uea_driver;
 static DEFINE_MUTEX(uea_mutex);
-static const char *chip_name[] = {"ADI930", "Eagle I", "Eagle II", "Eagle III",
-								"Eagle IV"};
+static const char * const chip_name[] = {
+	"ADI930", "Eagle I", "Eagle II", "Eagle III", "Eagle IV"};
 
 static int modem_index;
 static unsigned int debug;
-- 
1.7.4.1

