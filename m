Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777Ab2JTWdp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 18:33:45 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:50269 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285Ab2JTWdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 18:33:32 -0400
From: "Ken O'Brien" <kernel@kenobrien.org>
To: gregkh@linuxfoundation.org
Cc: swetland@google.com, arve@android.com, viro@zeniv.linux.org.uk,
        dhowells@redhat.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, "Ken O'Brien" <kernel@kenobrien.org>
Subject: [PATCH 2/2] staging: android: binder.c: checkpatch.pl
Date: Sat, 20 Oct 2012 23:33:20 +0100
Message-Id: <1350772400-12347-2-git-send-email-kernel@kenobrien.org>
X-Mailer: git-send-email 1.7.12.4
In-Reply-To: <1350772400-12347-1-git-send-email-kernel@kenobrien.org>
References: <1350772400-12347-1-git-send-email-kernel@kenobrien.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed 3 instances of "WARNING: static const char * array should probably be static const char * const" warnings from checkpatch

Signed-off-by: Ken O'Brien <kernel@kenobrien.org>
---
 drivers/staging/android/binder.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index 8607628..b17f9ba 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -3218,7 +3218,7 @@ static void print_binder_proc(struct seq_file *m,
 		m->count = start_pos;
 }
 
-static const char *binder_return_strings[] = {
+static const char *const binder_return_strings[] = {
 	"BR_ERROR",
 	"BR_OK",
 	"BR_TRANSACTION",
@@ -3239,7 +3239,7 @@ static const char *binder_return_strings[] = {
 	"BR_FAILED_REPLY"
 };
 
-static const char *binder_command_strings[] = {
+static const char *const binder_command_strings[] = {
 	"BC_TRANSACTION",
 	"BC_REPLY",
 	"BC_ACQUIRE_RESULT",
@@ -3259,7 +3259,7 @@ static const char *binder_command_strings[] = {
 	"BC_DEAD_BINDER_DONE"
 };
 
-static const char *binder_objstat_strings[] = {
+static const char *const binder_objstat_strings[] = {
 	"proc",
 	"thread",
 	"node",
-- 
1.7.12.4

