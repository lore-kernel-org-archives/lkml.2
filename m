Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246Ab2BCN2J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 08:28:09 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:34984
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755024Ab2BCN2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 08:28:07 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: netdev@vger.kernel.org
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org, standby24x7@gmail.com
Subject: [PATCH] [trivial] mlx4: Fix typo in cmd.c
Date: Fri,  3 Feb 2012 22:27:38 +0900
Message-Id: <1328275658-1982-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling "reseting" to "resetting" in
drivers/net/ethernet/mellanox/mlx4/cmd.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx4/cmd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/cmd.c b/drivers/net/ethernet/mellanox/mlx4/cmd.c
index 405e6ac..1831dde 100644
--- a/drivers/net/ethernet/mellanox/mlx4/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx4/cmd.c
@@ -1314,7 +1314,7 @@ static void mlx4_master_do_cmd(struct mlx4_dev *dev, int slave, u8 cmd,
 		down(&priv->cmd.slave_sem);
 		if (mlx4_master_process_vhcr(dev, slave, NULL)) {
 			mlx4_err(dev, "Failed processing vhcr for slave:%d,"
-				 " reseting slave.\n", slave);
+				 " resetting slave.\n", slave);
 			up(&priv->cmd.slave_sem);
 			goto reset_slave;
 		}
-- 
1.7.6.5

