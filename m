Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400Ab2A3SgO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 13:36:14 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:38951 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794Ab2A3SgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 13:36:13 -0500
From: Autif Khan <tekxtc@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>,
        edwin_rong <edwin_rong@realsil.com.cn>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Autif Khan <tekxtc@gmail.com>
Subject: [PATCH 2/2] Fixed a coding style issue
Date: Mon, 30 Jan 2012 13:36:02 -0500
Message-Id: <1327948562-3548-1-git-send-email-tekxtc@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Autif Khan <tekxtc@gmail.com>
---
 drivers/staging/rts5139/rts51x_chip.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rts5139/rts51x_chip.h b/drivers/staging/rts5139/rts51x_chip.h
index 321ece7..13fc2a4 100644
--- a/drivers/staging/rts5139/rts51x_chip.h
+++ b/drivers/staging/rts5139/rts51x_chip.h
@@ -857,12 +857,12 @@ static inline u8 *rts51x_get_rsp_data(struct rts51x_chip *chip)
 	return chip->rsp_buf;
 }
 
-int rts51x_get_card_status(struct rts51x_chip *chip, u16 * status);
+int rts51x_get_card_status(struct rts51x_chip *chip, u16 *status);
 int rts51x_write_register(struct rts51x_chip *chip, u16 addr, u8 mask, u8 data);
-int rts51x_read_register(struct rts51x_chip *chip, u16 addr, u8 * data);
+int rts51x_read_register(struct rts51x_chip *chip, u16 addr, u8 *data);
 int rts51x_ep0_write_register(struct rts51x_chip *chip, u16 addr, u8 mask,
 			      u8 data);
-int rts51x_ep0_read_register(struct rts51x_chip *chip, u16 addr, u8 * data);
+int rts51x_ep0_read_register(struct rts51x_chip *chip, u16 addr, u8 *data);
 int rts51x_seq_write_register(struct rts51x_chip *chip, u16 addr, u16 len,
 			      u8 *data);
 int rts51x_seq_read_register(struct rts51x_chip *chip, u16 addr, u16 len,
-- 
1.7.4.1

