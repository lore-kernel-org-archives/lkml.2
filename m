Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902Ab1HRTLm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 15:11:42 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48361 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865Ab1HRTLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 15:11:40 -0400
Date: Thu, 18 Aug 2011 20:11:39 +0100
To: richard@nod.at
Subject: Subject: [PATCH 76/91] um: page_offset.h is never used
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Qu80B-000815-UG@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


... and neither is the only define in it

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/um/include/asm/page_offset.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)
 delete mode 100644 arch/um/include/asm/page_offset.h

diff --git a/arch/um/include/asm/page_offset.h b/arch/um/include/asm/page_offset.h
deleted file mode 100644
index 1c168df..0000000
--- a/arch/um/include/asm/page_offset.h
+++ /dev/null
@@ -1 +0,0 @@
-#define PAGE_OFFSET_RAW (uml_physmem)
-- 
1.7.2.5


