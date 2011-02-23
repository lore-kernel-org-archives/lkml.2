Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145Ab1BWFpM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 00:45:12 -0500
Received: from mail.perches.com ([173.55.12.10]:3855 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751789Ab1BWFmb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 00:42:31 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 07/18] MAINTAINERS: Update media path
Date: Tue, 22 Feb 2011 21:42:00 -0800
Message-Id: <565315e4561a8a74158f84974b91e097ab0b6bf4.1298439175.git.joe@perches.com>
X-Mailer: git-send-email 1.7.4.rc3
In-Reply-To: <cover.1298439175.git.joe@perches.com>
References: <cover.1298439175.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 52b661449aecc47e652a164c0d8078b31e10aca0
("[media] rc: Rename remote controller type to rc_type instead of ir_type")
moved it around.

cc: Maxim Levitsky <maximlevitsky@gmail.com>

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index c169e27..6556c9f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2447,8 +2447,7 @@ F:	include/linux/cb710.h
 ENE KB2426 (ENE0100/ENE020XX) INFRARED RECEIVER
 M:	Maxim Levitsky <maximlevitsky@gmail.com>
 S:	Maintained
-F:	drivers/media/IR/ene_ir.c
-F:	drivers/media/IR/ene_ir.h
+F:	drivers/media/rc/ene_ir.*
 
 EPSON 1355 FRAMEBUFFER DRIVER
 M:	Christopher Hoover <ch@murgatroid.com>
-- 
1.7.4.rc3

