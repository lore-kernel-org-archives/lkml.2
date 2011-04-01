Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758014Ab1DAPoZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 11:44:25 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:61830 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437Ab1DAPoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 11:44:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=NCuXR1m6sOeJIHftl7CiNhQZeH6W0itt2/J9wbTmI8jvPXPnH4oDKPk/kTT6gJ5eiv
         iGiGuRynby0LjpA+WM4ouyMlDIn4Wn/uWOIQeAUoujCBJnC1ZHuTYQTtjQ7FTe6ptD8j
         OP2dKdwJ6MTXPBfqrRfFF7hr5Z0sJZFm952CU=
MIME-Version: 1.0
Date: Fri, 1 Apr 2011 17:44:23 +0200
Message-ID: <BANLkTimKwW7d2x1RDCPnu1LHMBKHy3PYgw@mail.gmail.com>
Subject: [PATCH] Define a fixed elementary logic type
From: Georgette Boole <georgette.boole@googlemail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unfortunately, my father's elementary logic type is incomplete. This patch
introduces the correct type with a plan to transition the kernel over to
it and to deprecate the "bool" type in the v3.0 timeframe.

Signed-off-by: Georgette Boole <georgette.boole@googlemail.com>
---
diff --git a/include/linux/types.h b/include/linux/types.h
index 176da8c..80d9b0f 100644
--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -36,6 +36,14 @@ typedef __kernel_mqd_t		mqd_t;

 typedef _Bool			bool;

+enum _Wool {
+	w_false	= 0,
+	w_true	= 1,
+	w_maybe	= 1 / 2,
+};
+
+typedef enum _Wool		wool;
+
 typedef __kernel_uid32_t	uid_t;
 typedef __kernel_gid32_t	gid_t;
 typedef __kernel_uid16_t        uid16_t;
