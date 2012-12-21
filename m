Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700Ab2LUXI5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 18:08:57 -0500
Received: from mail-da0-f42.google.com ([209.85.210.42]:61803 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617Ab2LUXIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 18:08:52 -0500
X-Greylist: delayed 477 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Dec 2012 18:08:52 EST
From: Cruz Julian Bishop <cruzjbishop@gmail.com>
To: greg@kroah.com
Cc: swetland@google.com, linux-kernel@vger.kernel.org,
        Cruz Julian Bishop <cruzjbishop@gmail.com>
Subject: [PATCH 2/3] staging: android: Fix two checkpatch issues in binder.c
Date: Sat, 22 Dec 2012 09:00:45 +1000
Message-Id: <1356130846-6973-3-git-send-email-cruzjbishop@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1356130846-6973-1-git-send-email-cruzjbishop@gmail.com>
References: <1356130846-6973-1-git-send-email-cruzjbishop@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes two instances of
"static const char * array should probably be static const char * const"

I have seen other commits doing this in other files, so I am
assuming it should be done here as well.

Please tell me if this is wrong :)

Signed-off-by: Cruz Julian Bishop <cruzjbishop@gmail.com>
---
 drivers/staging/android/binder.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index 2d12e8a..538ebe2 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -3227,7 +3227,7 @@ static void print_binder_proc(struct seq_file *m,
 		m->count = start_pos;
 }
 
-static const char *binder_return_strings[] = {
+static const char * const binder_return_strings[] = {
 	"BR_ERROR",
 	"BR_OK",
 	"BR_TRANSACTION",
@@ -3248,7 +3248,7 @@ static const char *binder_return_strings[] = {
 	"BR_FAILED_REPLY"
 };
 
-static const char *binder_command_strings[] = {
+static const char * const binder_command_strings[] = {
 	"BC_TRANSACTION",
 	"BC_REPLY",
 	"BC_ACQUIRE_RESULT",
@@ -3268,7 +3268,7 @@ static const char *binder_command_strings[] = {
 	"BC_DEAD_BINDER_DONE"
 };
 
-static const char *binder_objstat_strings[] = {
+static const char * const binder_objstat_strings[] = {
 	"proc",
 	"thread",
 	"node",
-- 
1.7.10.4

