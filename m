Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934418Ab0EZHKO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 03:10:14 -0400
Received: from crca.org.au ([74.207.252.120]:54273 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934331Ab0EZHKE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 03:10:04 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4BFCC948.8010603@crca.org.au>
Date: Wed, 26 May 2010 17:10:00 +1000
From: Nigel Cunningham <ncunningham@crca.org.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       TuxOnIce-devel <tuxonice-devel@tuxonice.net>
Subject: [PATCH 2/5]  Move root swap declaration.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
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
index 829f7b4..e555b6c 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -63,6 +63,8 @@ struct swap_map_handle {
  	unsigned int k;
  };

+static unsigned short root_swap = 0xffff;
+
  struct swsusp_header {
  	char reserved[PAGE_SIZE - 20 - sizeof(sector_t) - sizeof(int)];
  	sector_t image;
@@ -217,7 +219,6 @@ int swsusp_swap_in_use(void)
   * General things
   */

-static unsigned short root_swap = 0xffff;
  struct block_device *hib_resume_bdev;

  /*
-- 
1.7.0.4

