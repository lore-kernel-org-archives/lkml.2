Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932208Ab1C1Qby (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 12:31:54 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39860 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932109Ab1C1Qaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 12:30:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=v+3fmgy2sngm6BvoQZzWfKWT0CSiSRC6kjcopKqvVqWYBTub/+6ViYiJIq4ykwYl1c
         5mIA8QddzbjdhpD2bJ2hwvnsH2ddDQBJGs5jCgI5G/ewYEUi2VeHlzOzPZZMdU5QGh7d
         7P0pP66Tn7cD2BpqvcZ4XCnf1hgq11YHG28cE=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 21/25]init:version.c Remove version.h since it is unused.
Date: Mon, 28 Mar 2011 09:29:44 -0700
Message-Id: <1301329788-3423-22-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1301329788-3423-1-git-send-email-justinmattock@gmail.com>
References: <1301329788-3423-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes <linux/version.h> since it is nolonger
in the kernel.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 init/version.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/init/version.c b/init/version.c
index 86fe0cc..49d2853 100644
--- a/init/version.c
+++ b/init/version.c
@@ -11,7 +11,6 @@
 #include <linux/uts.h>
 #include <linux/utsname.h>
 #include <generated/utsrelease.h>
-#include <linux/version.h>
 
 #ifndef CONFIG_KALLSYMS
 #define version(a) Version_ ## a
-- 
1.7.4.1

