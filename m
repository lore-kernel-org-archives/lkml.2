Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305Ab2EEOdQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 10:33:16 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:61809 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755556Ab2EEOcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 10:32:31 -0400
From: Johannes Thumshirn <morbidrsa@googlemail.com>
To: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: grabner@icg.tugraz.at, andor.daam@googlemail.com, thomas@m3y3r.de,
        jj@chaosbits.net, stefanha@gmail.com,
        Johannes Thumshirn <morbidrsa@googlemail.com>
Subject: [PATCH 7/8] drivers/staging/line6/midi.c: Added space between switch and open parenthesis
Date: Sat,  5 May 2012 16:31:51 +0200
Message-Id: <1336228312-5379-8-git-send-email-morbidrsa@googlemail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1336228312-5379-1-git-send-email-morbidrsa@googlemail.com>
References: <1336228312-5379-1-git-send-email-morbidrsa@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added space between switch and open parenthesis to make checkpatch.pl happy

Signed-off-by: Johannes Thumshirn <morbidrsa@googlemail.com>
---
 drivers/staging/line6/midi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/line6/midi.c b/drivers/staging/line6/midi.c
index 13d0293..5040729 100644
--- a/drivers/staging/line6/midi.c
+++ b/drivers/staging/line6/midi.c
@@ -406,7 +406,7 @@ int line6_init_midi(struct usb_line6 *line6)
 
 	line6midi->line6 = line6;
 
-	switch(line6->product) {
+	switch (line6->product) {
 	case LINE6_DEVID_PODHD300:
 	case LINE6_DEVID_PODHD500:
 		line6midi->midi_mask_transmit = 1;
-- 
1.7.7.6

