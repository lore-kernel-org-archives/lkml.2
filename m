Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045Ab1GLKvE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 06:51:04 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59308 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752958Ab1GLKvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 06:51:03 -0400
From: Ravishankar <ravishankarkm32@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>,
        Ravishankar <ravishankarkm32@gmail.com>
Subject: [PATCH 22/22] Staging: comedi: fix warning:line over 80 character issue in ke_counter.c
Date: Tue, 12 Jul 2011 16:33:39 +0530
Message-Id: <1310468619-9810-1-git-send-email-ravishankarkm32@gmail.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <[PATCH]Staging: comedi: fix line over 80 character warning issue in ke_counter.c>
References: <[PATCH]Staging: comedi: fix line over 80 character warning issue in ke_counter.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ravishankar <ravi.shankar@greenturtles.in>

This is a patch to the ke_counter.c file that fixes up a warning: line over 80 character found by the checkpatch.pl tool

Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>
---
 drivers/staging/comedi/drivers/ke_counter.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ke_counter.c b/drivers/staging/comedi/drivers/ke_counter.c
index 286093b..e9fdca9 100644
--- a/drivers/staging/comedi/drivers/ke_counter.c
+++ b/drivers/staging/comedi/drivers/ke_counter.c
@@ -204,10 +204,14 @@ static int cnt_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 			for (i = 0; i < cnt_board_nbr; i++) {
 				if (cnt_boards[i].device_id ==
 				    pci_device->device) {
-					/* was a particular bus/slot requested? */
+					/* was a particular bus/slot
+					 * requested?
+					 */
 					if ((it->options[0] != 0)
 					    || (it->options[1] != 0)) {
-						/* are we on the wrong bus/slot? */
+						/* are we on the wrong
+						 * bus/slot?
+						 */
 						if (pci_device->bus->number !=
 						    it->options[0]
 						    ||
-- 
1.6.5.2

