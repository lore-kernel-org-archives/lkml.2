Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160Ab0H1CZU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 22:25:20 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:48214 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971Ab0H1CZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 22:25:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=hlj+qHQB6RjHZcQQGhn4qzaoYKgWwqFqfTxl6DopZ3JxqZRBuixge0j3U+cFkoBkqY
         Yz+aYCw9yXnqpNqWKsha9I2H31zJ40zTLd2mgR2DTA6VriRO+skOJ2VTUjeEY6S13k0r
         eu9UYW20G+/ZqE4rju7pw+EGPq/+YF8/o3/b8=
From: Yong Zhang <yong.zhang0@gmail.com>
To: john.johansen@canonical.com, jmorris@namei.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: [PATCH] .gitignore: ignore apparmor/rlim_names.h
Date: Sat, 28 Aug 2010 10:25:09 +0800
Message-Id: <1282962309-3331-1-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yong Zhang <yong.zhang@windriver.com>

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
---
 security/apparmor/.gitignore |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/security/apparmor/.gitignore b/security/apparmor/.gitignore
index 0a0a99f..4d995ae 100644
--- a/security/apparmor/.gitignore
+++ b/security/apparmor/.gitignore
@@ -3,3 +3,4 @@
 #
 af_names.h
 capability_names.h
+rlim_names.h
-- 
1.7.0.4

