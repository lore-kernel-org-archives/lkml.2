Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591Ab3AGSMT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 13:12:19 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:53190 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180Ab3AGSMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 13:12:18 -0500
From: Patrik Karlin <patrik.karlin@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Patrik Karlin <patrik.karlin@gmail.com>
Subject: =?UTF-8?q?=5BPATCH=5D=20Staging=3A=20android=3A=20fixed=20const=20coding=20style=20issue=20in=20binder=2Ec?=
Date: Mon,  7 Jan 2013 19:11:52 +0100
Message-Id: <1357582312-3024-1-git-send-email-patrik.karlin@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <no>
References: <no>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to add const to the lists of strings in binder.c
as suggested by checkpatch.pl

Signed-off-by: Patrik Kårlin <patrik.karlin@gmail.com>
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

