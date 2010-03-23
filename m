Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab0CWT6b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 15:58:31 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:56355 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872Ab0CWT6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 15:58:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer;
        b=byEQK0Xivzau6VMKqCIZmiM43+OhyUid/LYNmMKs4sTqhN5Dqp8RSEw5VdXUxmvGJU
         sUkn84AMKFYHgT4iCaVw1RWHLDGWjDsTwm7QeIyleXu7b9rCOtLzCSOGWTkjaNtuPikX
         yKI1dODdOAUQV7MNE/tQiVwKW+mkF0UPN7fE0=
From: Maurice Dawson <mauricedawson2699@googlemail.com>
To: gregkh@suse.de, wfp5p@virginia.edu, mithlesh@linsyssoft.com,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 22/22] Staging: comedi: fix space coding style issue in adq12b.c
Date: Tue, 23 Mar 2010 19:58:17 +0000
Message-Id: <1269374297-3894-1-git-send-email-mauricedawson2699@googlemail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the adq12b.c file that fixes up a space warning found by the checkpatch.pl tool

Signed-off-by: Maurice Dawson <mauricedawson2699@googlemail.com>
---
 drivers/staging/comedi/drivers/adq12b.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adq12b.c b/drivers/staging/comedi/drivers/adq12b.c
index b51813b..00b2009 100644
--- a/drivers/staging/comedi/drivers/adq12b.c
+++ b/drivers/staging/comedi/drivers/adq12b.c
@@ -166,12 +166,12 @@ static int adq12b_attach(struct comedi_device *dev,
 static int adq12b_detach(struct comedi_device *dev);
 static struct comedi_driver driver_adq12b = {
 driver_name:"adq12b",
-module:THIS_MODULE,
-attach:adq12b_attach,
-detach:adq12b_detach,
-board_name:&adq12b_boards[0].name,
-offset:sizeof(struct adq12b_board),
-num_names:ARRAY_SIZE(adq12b_boards),
+module : THIS_MODULE,
+attach : adq12b_attach,
+detach : adq12b_detach,
+board_name : &adq12b_boards[0].name,
+offset : sizeof(struct adq12b_board),
+num_names : ARRAY_SIZE(adq12b_boards),
 };
 
 static int adq12b_ai_rinsn(struct comedi_device *dev,
-- 
1.6.3.3

