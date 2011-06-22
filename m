Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757567Ab1FVL4J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 07:56:09 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:13380 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757427Ab1FVL4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 07:56:07 -0400
Date: Wed, 22 Jun 2011 13:47:16 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Randy Dunlap <rdunlap@xenotime.net>
cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Update reference to memory allocators in CodingStyle to
 include vzalloc()
Message-ID: <alpine.LNX.2.00.1106221345001.11593@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The list of available general purpose memory allocators in
Documentation/CodingStyle chapter 14 is incomplete. This patch adds
the missing vzalloc() to the list.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 Documentation/CodingStyle |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/CodingStyle b/Documentation/CodingStyle
index 58b0bf9..fa6e25b 100644
--- a/Documentation/CodingStyle
+++ b/Documentation/CodingStyle
@@ -680,8 +680,8 @@ ones already enabled by DEBUG.
 		Chapter 14: Allocating memory
 
 The kernel provides the following general purpose memory allocators:
-kmalloc(), kzalloc(), kcalloc(), and vmalloc().  Please refer to the API
-documentation for further information about them.
+kmalloc(), kzalloc(), kcalloc(), vmalloc(), and vzalloc().  Please refer to
+the API documentation for further information about them.
 
 The preferred form for passing a size of a struct is the following:
 
-- 
1.7.5.2

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

