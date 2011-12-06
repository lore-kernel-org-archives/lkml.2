Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601Ab1LFKaP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 05:30:15 -0500
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:46989 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966Ab1LFKaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 05:30:13 -0500
Message-ID: <1323167408.1822.10.camel@x61.thuisdomein>
Subject: [PATCH] [TRIVIAL] sis900: Fix enum typo 'sis900_rx_bufer_status'
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Date: Tue, 06 Dec 2011 11:30:08 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
This is a follow up to (trivial's) commit 90802ed9c3 ("treewide: Fix
comment and string typo 'bufer'"). I wanted to compile test this typo,
just to be safe. (But note that the name of this enum isn't actually
used anywhere.) Now that I have done that it's clear that I could as
well have merged this patch with the patch for those other typos.
Perhaps Jiri can still do that.

 drivers/net/ethernet/sis/sis900.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/sis/sis900.h b/drivers/net/ethernet/sis/sis900.h
index 150511a..1341f33 100644
--- a/drivers/net/ethernet/sis/sis900.h
+++ b/drivers/net/ethernet/sis/sis900.h
@@ -205,7 +205,7 @@ enum sis900_tx_buffer_status {
 	EXCCOLL = 0x00100000, COLCNT   = 0x000F0000
 };
 
-enum sis900_rx_bufer_status {
+enum sis900_rx_buffer_status {
 	OVERRUN = 0x02000000, DEST = 0x00800000,     BCAST = 0x01800000,
 	MCAST   = 0x01000000, UNIMATCH = 0x00800000, TOOLONG = 0x00400000,
 	RUNT    = 0x00200000, RXISERR  = 0x00100000, CRCERR  = 0x00080000,
-- 
1.7.7.3

