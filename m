Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762331Ab0GUFAw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 01:00:52 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43804 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762321Ab0GUE7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:59:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=xGQDcAArOgEeihaoFAS4SmdJKp0JC0QwqDPSP+WSXyGtjmcJ+nPgxmpQCNxPg8Z4dc
         lZyYAoUyayITIBfkrEwlMzZ6OqVd/A+psxF67s0XDD7YZ04SvklcNIy/syxaDJMIpekx
         tgQEFTzgsLYNn1l00SllqXe6aiYV16XRhhwKM=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 138/138]Documentation/zh_CN/SubmittingDrivers update web address.
Date: Tue, 20 Jul 2010 21:58:55 -0700
Message-Id: <1279688336-29735-18-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279688336-29735-1-git-send-email-justinmattock@gmail.com>
References: <1279688336-29735-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below updates a broken web address.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/zh_CN/SubmittingDrivers |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/zh_CN/SubmittingDrivers b/Documentation/zh_CN/SubmittingDrivers
index 5f4815c..c27b0f6 100644
--- a/Documentation/zh_CN/SubmittingDrivers
+++ b/Documentation/zh_CN/SubmittingDrivers
@@ -165,4 +165,4 @@ Linux USB项目：
 	http://www.fenrus.org/how-to-not-write-a-device-driver-paper.pdf
 
 内核清洁工 (Kernel Janitor):
-	http://janitor.kernelnewbies.org/
+	http://kernelnewbies.org/KernelJanitors
-- 
1.7.1.rc1.21.gf3bd6

