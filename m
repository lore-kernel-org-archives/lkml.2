Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387Ab1IDTyD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Sep 2011 15:54:03 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:40384 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753237Ab1IDTxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Sep 2011 15:53:55 -0400
From: Arvydas Sidorenko <asido4@gmail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org, asido4@gmail.com
Subject: [PATCH 1/3] one typo fix
Date: Sun,  4 Sep 2011 21:54:43 +0200
Message-Id: <1315166085-27984-1-git-send-email-asido4@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Arvydas Sidorenko <asido4@gmail.com>
---
 drivers/staging/crystalhd/bc_dts_defs.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/crystalhd/bc_dts_defs.h b/drivers/staging/crystalhd/bc_dts_defs.h
index 778e76a..8c6ac3e 100644
--- a/drivers/staging/crystalhd/bc_dts_defs.h
+++ b/drivers/staging/crystalhd/bc_dts_defs.h
@@ -84,7 +84,7 @@ enum BC_SW_OPTIONS {
 	BC_OPT_LINK_OUT_ENCRYPT		= BC_BIT(29),
 };
 
-struct BC_REG_CONFIG{
+struct BC_REG_CONFIG {
 	uint32_t		DbgOptions;
 };
 
-- 
1.7.1

