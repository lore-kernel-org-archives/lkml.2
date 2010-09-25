Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246Ab0IYERR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 00:17:17 -0400
Received: from crca.org.au ([74.207.252.120]:35139 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932092Ab0IYERO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 00:17:14 -0400
X-Bogosity: Ham, spamicity=0.000000
From: Nigel Cunningham <nigel@tuxonice.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        TuxOnIce-devel <tuxonice-devel@tuxonice.net>
Subject: [PATCH 03/22] Hibernation: Move root_swap declaration.
Date: Sat, 25 Sep 2010 14:16:45 +1000
Message-Id: <1285388224-10012-4-git-send-email-nigel@tuxonice.net>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1285388224-10012-1-git-send-email-nigel@tuxonice.net>
References: <1285388224-10012-1-git-send-email-nigel@tuxonice.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the declaration of root_swap in preparation for the
next patch.

Signed-off-by: Nigel Cunningham <nigel@tuxonice.net>
---
 kernel/power/swap.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index d53417b..587f851 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -63,6 +63,8 @@ struct swap_map_handle {
 	unsigned int k;
 };
 
+static unsigned short root_swap = 0xffff;
+
 struct swsusp_header {
 	char reserved[PAGE_SIZE - 21 - sizeof(sector_t) - sizeof(int)];
 	char write_speed;
@@ -218,7 +220,6 @@ int swsusp_swap_in_use(void)
  * General things
  */
 
-static unsigned short root_swap = 0xffff;
 struct block_device *hib_resume_bdev;
 char __nosavedata write_speed, read_speed;
 
-- 
1.7.0.4

