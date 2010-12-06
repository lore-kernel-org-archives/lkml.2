Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175Ab0LFOhK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 09:37:10 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47251 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204Ab0LFOhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 09:37:08 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH] staging/comedi: remove German in-file changelog
Date: Mon,  6 Dec 2010 15:37:02 +0100
Message-Id: <1291646222-16322-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My script that finds typos always wants to do s/Funktion/Function/.
Instead of adding some whilelist logic to my script just delete the
changelog that is useless in general and still more in this case as most
kernel developers don't understand it.

Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 .../comedi/drivers/addi-data/APCI1710_Ssi.c        |   14 --------------
 1 files changed, 0 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/APCI1710_Ssi.c b/drivers/staging/comedi/drivers/addi-data/APCI1710_Ssi.c
index 0c890a9..2b19823 100644
--- a/drivers/staging/comedi/drivers/addi-data/APCI1710_Ssi.c
+++ b/drivers/staging/comedi/drivers/addi-data/APCI1710_Ssi.c
@@ -38,20 +38,6 @@ You should also find the complete GPL in the COPYING file accompanying this sour
   |                                                                       |
   |                                                                       |
   +-----------------------------------------------------------------------+
-  |                             UPDATES                                   |
-  +-----------------------------------------------------------------------+
-  |   Date   |   Author  |          Description of updates                |
-  +----------+-----------+------------------------------------------------+
-  | 13/05/98 | S. Weber  | SSI digital input / output implementation      |
-  |----------|-----------|------------------------------------------------|
-  | 22/03/00 | C.Guinot  | 0100/0226 -> 0200/0227                         |
-  |          |           | Änderung in InitSSI Funktion                   |
-  |          |           | b_SSIProfile >= 2 anstatt b_SSIProfile > 2     |
-  |          |           |                                                |
-  +-----------------------------------------------------------------------+
-  | 08/05/00 | Guinot C  | - 0400/0228 All Function in RING 0             |
-  |          |           |   available                                    |
-  +-----------------------------------------------------------------------+
 */
 
 /*
-- 
1.7.2.3

