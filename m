Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995Ab0HBQAm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 12:00:42 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:64408 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752856Ab0HBQAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 12:00:41 -0400
Date: Mon, 2 Aug 2010 18:00:38 +0200
From: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
To: Mike Frysinger <vapier@gentoo.org>, Robin Getz <robin.getz@analog.com>,
        Tejun Heo <tj@kernel.org>, uclinux-dist-devel@blackfin.uclinux.org,
        linux-kernel@vger.kernel.org
Cc: vamos-dev@i4.informatik.uni-erlangen.de
Subject: [PATCH 1/6] arch/blackfin: Remove config HIGHMEM
Message-ID: <7c1104f5f4e78fa90e45850239a2484b6e224b0d.1280764206.git.qy03fugy@stud.informatik.uni-erlangen.de>
References: <cover.1280764206.git.qy03fugy@stud.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1280764206.git.qy03fugy@stud.informatik.uni-erlangen.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_HIGHMEM can't be selected in blackfin, therefore all references
to it can be removed from the arch/blackfin.

Signed-off-by: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
---
 arch/blackfin/mm/init.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/blackfin/mm/init.c b/arch/blackfin/mm/init.c
index bb4e8ff..07ebd3a 100644
--- a/arch/blackfin/mm/init.c
+++ b/arch/blackfin/mm/init.c
@@ -49,9 +49,6 @@ void __init paging_init(void)
 		[0] = 0,
 		[ZONE_DMA] = (end_mem - PAGE_OFFSET) >> PAGE_SHIFT,
 		[ZONE_NORMAL] = 0,
-#ifdef CONFIG_HIGHMEM
-		[ZONE_HIGHMEM] = 0,
-#endif
 	};
 
 	/* Set up SFC/DFC registers (user data space) */
-- 
1.7.0.4

