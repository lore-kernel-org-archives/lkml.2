Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762230Ab0GUE4L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 00:56:11 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:51115 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762186Ab0GUEzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:55:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=lpwAKfV5sDfq1ECjfgk8iJjBaUXwmdJuSBoZ4UJSGKRw981CDW5SQh1fHtfX5GgdTy
         FSXltvxKzj6Rd/Qc3mqocTjV/U+Ey++/bMnTcwHh+tfvibNVEs0i5KIky3hS17CjBfzK
         LB8kNHUZmjLzsKS74v8ZlrLvg3wNB0SkwgEHE=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 70/70]Documentation/md.txt update web address.
Date: Tue, 20 Jul 2010 21:54:51 -0700
Message-Id: <1279688096-29519-10-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279688096-29519-1-git-send-email-justinmattock@gmail.com>
References: <1279688096-29519-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Th epatch below updates a broken web address.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/md.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/md.txt b/Documentation/md.txt
index e4e893e..a81c7b4 100644
--- a/Documentation/md.txt
+++ b/Documentation/md.txt
@@ -1,5 +1,5 @@
 Tools that manage md devices can be found at
-   http://www.<country>.kernel.org/pub/linux/utils/raid/....
+   http://www.kernel.org/pub/linux/utils/raid/ 
 
 
 Boot time assembly of RAID arrays
-- 
1.7.1.rc1.21.gf3bd6

