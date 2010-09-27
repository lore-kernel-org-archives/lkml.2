Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932672Ab0I0FoM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 01:44:12 -0400
Received: from crca.org.au ([74.207.252.120]:58357 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932655Ab0I0FoK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 01:44:10 -0400
X-Bogosity: Ham, spamicity=0.000000
From: Nigel Cunningham <nigel@tuxonice.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        TuxOnIce-devel <tuxonice-devel@tuxonice.net>
Subject: [PATCH 04/23] Hibernation: Move root_swap declaration.
Date: Mon, 27 Sep 2010 15:43:39 +1000
Message-Id: <1285566238-10966-5-git-send-email-nigel@tuxonice.net>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1285566238-10966-1-git-send-email-nigel@tuxonice.net>
References: <1285566238-10966-1-git-send-email-nigel@tuxonice.net>
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
index 4e5f6e3..25090ed 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -44,6 +44,8 @@ struct swap_map_page {
 	sector_t next_swap;
 };
 
+static unsigned short root_swap = 0xffff;
+
 struct swsusp_header {
 	char reserved[PAGE_SIZE - 21 - sizeof(sector_t) - sizeof(int)];
 	char write_speed;
@@ -199,7 +201,6 @@ int swsusp_swap_in_use(void)
  * General things
  */
 
-static unsigned short root_swap = 0xffff;
 struct block_device *hib_resume_bdev;
 char __nosavedata write_speed, read_speed;
 
-- 
1.7.0.4

