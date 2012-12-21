Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752416Ab2LUXIr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 18:08:47 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:64302 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288Ab2LUXIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 18:08:45 -0500
From: Cruz Julian Bishop <cruzjbishop@gmail.com>
To: greg@kroah.com
Cc: swetland@google.com, linux-kernel@vger.kernel.org,
        Cruz Julian Bishop <cruzjbishop@gmail.com>
Subject: [PATCH 1/3] staging: android: Avoid using camelcase in binder.h
Date: Sat, 22 Dec 2012 09:00:44 +1000
Message-Id: <1356130846-6973-2-git-send-email-cruzjbishop@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1356130846-6973-1-git-send-email-cruzjbishop@gmail.com>
References: <1356130846-6973-1-git-send-email-cruzjbishop@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This changes the following:

1: BinderDriverReturnProtocol -> binder_driver_return_protocol
2: BinderDriverCommandProtocol -> binder_driver_return_protocol

These enums are not currently used, but still generate noise in checkpatch.

Well, did. They don't now :)

Signed-off-by: Cruz Julian Bishop <cruzjbishop@gmail.com>
---
 drivers/staging/android/binder.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/android/binder.h b/drivers/staging/android/binder.h
index 2f7d195..76ead8d 100644
--- a/drivers/staging/android/binder.h
+++ b/drivers/staging/android/binder.h
@@ -163,7 +163,7 @@ struct binder_pri_ptr_cookie {
 	void *cookie;
 };
 
-enum BinderDriverReturnProtocol {
+enum binder_driver_return_protocol {
 	BR_ERROR = _IOR('r', 0, int),
 	/*
 	 * int: error code
@@ -251,7 +251,7 @@ enum BinderDriverReturnProtocol {
 	 */
 };
 
-enum BinderDriverCommandProtocol {
+enum binder_driver_command_protocol {
 	BC_TRANSACTION = _IOW('c', 0, struct binder_transaction_data),
 	BC_REPLY = _IOW('c', 1, struct binder_transaction_data),
 	/*
-- 
1.7.10.4

