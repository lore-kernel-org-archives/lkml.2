Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758412Ab2CMAxt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:53:49 -0400
Received: from mail.windriver.com ([147.11.1.11]:47942 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758796Ab2CMAWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:22:55 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Greg Rose <gregory.v.rose@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 096/196] Remove extra struct page member from the buffer info structure
Date: Mon, 12 Mar 2012 20:20:09 -0400
Message-Id: <1331598109-31424-51-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Rose <gregory.v.rose@intel.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit b1d670f10e8078485884f0cf7e384d890909aeaa upstream.

declaration.

Reported-by: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Greg Rose <gregory.v.rose@intel.com>
Tested-by: Emil Tantilov <emil.s.tantilov@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/net/igbvf/igbvf.h |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/igbvf/igbvf.h b/drivers/net/igbvf/igbvf.h
index debeee2..f7ae284 100644
--- a/drivers/net/igbvf/igbvf.h
+++ b/drivers/net/igbvf/igbvf.h
@@ -126,7 +126,6 @@ struct igbvf_buffer {
 			unsigned int page_offset;
 		};
 	};
-	struct page *page;
 };
 
 union igbvf_desc {
-- 
1.7.9.3

