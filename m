Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332Ab1DFOtE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 10:49:04 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45170 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755963Ab1DFOtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 10:49:02 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH] staging/comedi: remove German in-file changelog
Date: Wed,  6 Apr 2011 16:48:53 +0200
Message-Id: <1302101333-24431-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <20101206143906.52a52f21@lxorguk.ukuu.org.uk>
References: <20101206143906.52a52f21@lxorguk.ukuu.org.uk>
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
 .../comedi/drivers/addi-data/APCI1710_Ssi.c        |   16 +---------------
 1 files changed, 1 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/APCI1710_Ssi.c b/drivers/staging/comedi/drivers/addi-data/APCI1710_Ssi.c
index 0c890a9..c13b002 100644
--- a/drivers/staging/comedi/drivers/addi-data/APCI1710_Ssi.c
+++ b/drivers/staging/comedi/drivers/addi-data/APCI1710_Ssi.c
@@ -35,22 +35,8 @@ You should also find the complete GPL in the COPYING file accompanying this sour
   | Project manager: Eric Stolz   | Date     :  02/12/2002                |
   +-----------------------------------------------------------------------+
   | Description :   APCI-1710 SSI counter module                          |
-  |                                                                       |
-  |                                                                       |
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
+  | several changes done by S. Weber in 1998 and C. Guinot in 2000        |
   +-----------------------------------------------------------------------+
 */
 
-- 
1.7.2.3

