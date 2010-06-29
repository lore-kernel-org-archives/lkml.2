Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754343Ab0F2MbZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 08:31:25 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41283 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753900Ab0F2MbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 08:31:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=MpgdTMBqMUKPgi5gOBBd85OtJK0ZZ3WX2bMmdQN1d/6ACcph4oYhIfIuATkuK7hzWG
         LArIR9ww8i9D2znHzP0mKRQPW2Tn4AB5o4TrLdOpKpbbt6RpQWGnSQYbpoj/sKSjIqg4
         VcUfkL8W9pa96AfJeOG4y4YtqgIlZShCSaf+4=
From: Kulikov Vasiliy <segooon@gmail.com>
To: trivial@kernel.org
Cc: Randy Dunlap <rdunlap@xenotime.net>, Julia Lawall <julia@diku.dk>,
       Nicolas Palix <npalix@diku.dk>, Michal Marek <mmarek@suse.cz>,
       linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: [PATCH] Documentation: fix ubuntu distro name
Date: Tue, 29 Jun 2010 16:31:16 +0400
Message-Id: <1277814677-1944-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

10.04 is Lucid, not Karmic.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 Documentation/coccinelle.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/coccinelle.txt b/Documentation/coccinelle.txt
index ba3315d..cd2b028 100644
--- a/Documentation/coccinelle.txt
+++ b/Documentation/coccinelle.txt
@@ -14,7 +14,7 @@ of many distributions, e.g. :
 
  - Debian (>=squeeze)
  - Fedora (>=13)
- - Ubuntu (>=10.04 Karmic Koala)
+ - Ubuntu (>=10.04 Lucid Lynx)
  - OpenSUSE
  - Arch Linux
  - NetBSD
-- 
1.7.0.4

