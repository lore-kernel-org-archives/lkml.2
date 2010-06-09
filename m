Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932513Ab0FITiu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 15:38:50 -0400
Received: from mail.perches.com ([173.55.12.10]:2949 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932451Ab0FITiq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 15:38:46 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Ben Nizette <bn@niasdigital.com>
Subject: [PATCH 08/12] MAINTAINERS: Remove section SMX UIO Interface
Date: Wed,  9 Jun 2010 12:38:34 -0700
Message-Id: <864afd7fe86e75278b76c1f32f2c85306c98d6e6.1276112117.git.joe@perches.com>
X-Mailer: git-send-email 1.7.1.244.gbdc4
In-Reply-To: <cover.1276112117.git.joe@perches.com>
References: <cover.1276112117.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit d6e976c0d258c9547a308bd8a9a82ec93e2bc6e2
removed the file

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Ben Nizette <bn@niasdigital.com>
---
 MAINTAINERS |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 765322e..8aac474 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5226,11 +5226,6 @@ L:	netdev@vger.kernel.org
 S:	Supported
 F:	drivers/net/smsc9420.*
 
-SMX UIO Interface
-M:	Ben Nizette <bn@niasdigital.com>
-S:	Maintained
-F:	drivers/uio/uio_smx.c
-
 SN-IA64 (Itanium) SUB-PLATFORM
 M:	Jes Sorensen <jes@sgi.com>
 L:	linux-altix@sgi.com
-- 
1.7.1.244.gbdc4

