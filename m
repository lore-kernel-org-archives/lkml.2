Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420Ab1A1UAV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 15:00:21 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:14204 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278Ab1A1UAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 15:00:20 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Fri, 28 Jan 2011 11:48:57 -0800
From: riyer@nvidia.com
To: dmitry.torokhov@gmail.com
Cc: olof@lixom.net, achew@nvidia.com, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        Rakesh Iyer <riyer@nvidia.com>
Subject: [PATCH v1] input: tegra-kbc: Fix keymap for LeftMeta key.
Date: Fri, 28 Jan 2011 12:01:44 -0800
Message-Id: <1296244904-31118-1-git-send-email-riyer@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rakesh Iyer <riyer@nvidia.com>

Correct key mapping for Left Meta key.

Signed-off-by: Rakesh Iyer <riyer@nvidia.com>
---
 drivers/input/keyboard/tegra-kbc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/input/keyboard/tegra-kbc.c b/drivers/input/keyboard/tegra-kbc.c
index 9394766..6ca903a 100644
--- a/drivers/input/keyboard/tegra-kbc.c
+++ b/drivers/input/keyboard/tegra-kbc.c
@@ -86,7 +86,7 @@ static const u32 tegra_kbc_default_keymap[] = {
 	KEY(0, 5, KEY_Z),
 	KEY(0, 7, KEY_FN),
 
-	KEY(1, 7, KEY_MENU),
+	KEY(1, 7, KEY_LEFTMETA),
 
 	KEY(2, 6, KEY_RIGHTALT),
 	KEY(2, 7, KEY_LEFTALT),
-- 
1.7.0.4

