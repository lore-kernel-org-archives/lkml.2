Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989Ab1AKAX3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 19:23:29 -0500
Received: from kroah.org ([198.145.64.141]:45155 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754681Ab1AKAX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 19:23:28 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Brandon Philips <brandon@ifup.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 1/4] driver core: fix whitespace in class_attr_string
Date: Mon, 10 Jan 2011 16:23:22 -0800
Message-Id: <1294705405-31471-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110110234825.GA30018@kroah.com>
References: <20110110234825.GA30018@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Brandon Philips <brandon@ifup.org>

869dfc875e3 addded a long line and indented with spaces. Fix.

Signed-off-by: Brandon Philips <brandon@ifup.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/class.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/base/class.c b/drivers/base/class.c
index 9c63a56..7975a52 100644
--- a/drivers/base/class.c
+++ b/drivers/base/class.c
@@ -482,8 +482,8 @@ void class_interface_unregister(struct class_interface *class_intf)
 	class_put(parent);
 }
 
-ssize_t show_class_attr_string(struct class *class, struct class_attribute *attr,
-                        	char *buf)
+ssize_t show_class_attr_string(struct class *class,
+			       struct class_attribute *attr, char *buf)
 {
 	struct class_attribute_string *cs;
 	cs = container_of(attr, struct class_attribute_string, attr);
-- 
1.7.3.2

