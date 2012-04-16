Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847Ab2DPCcS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 22:32:18 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:50799 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748Ab2DPCcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 22:32:17 -0400
From: Valentin Ilie <valentin.ilie@gmail.com>
To: arve@android.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Valentin Ilie <valentin.ilie@gmail.com>
Subject: [PATCH] Staging: android: binder.c const char* smth TO const char * const smth
Date: Mon, 16 Apr 2012 05:31:34 +0300
Message-Id: <1334543494-13425-1-git-send-email-valentin.ilie@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replaced static const char* var with static const char * var const smth because
smth doesn't need to be reassigned at any point else at runtime.

Signed-off-by: Valentin Ilie <valentin.ilie@gmail.com>
---
 drivers/staging/android/binder.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index c283212..221bd3f 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -3303,7 +3303,7 @@ static void print_binder_proc(struct seq_file *m,
 		m->count = start_pos;
 }
 
-static const char *binder_return_strings[] = {
+static const char * const binder_return_strings[] = {
 	"BR_ERROR",
 	"BR_OK",
 	"BR_TRANSACTION",
@@ -3324,7 +3324,7 @@ static const char *binder_return_strings[] = {
 	"BR_FAILED_REPLY"
 };
 
-static const char *binder_command_strings[] = {
+static const char * const binder_command_strings[] = {
 	"BC_TRANSACTION",
 	"BC_REPLY",
 	"BC_ACQUIRE_RESULT",
@@ -3344,7 +3344,7 @@ static const char *binder_command_strings[] = {
 	"BC_DEAD_BINDER_DONE"
 };
 
-static const char *binder_objstat_strings[] = {
+static const char * const binder_objstat_strings[] = {
 	"proc",
 	"thread",
 	"node",
-- 
1.7.9.5

