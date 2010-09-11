Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755114Ab0IKDMy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 23:12:54 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61132 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754470Ab0IKDMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 23:12:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=eiJ8ggP15dGOkma+xczMsaatjdJOXOZJ/xkTy5hyBrkrSWgVFC4m8AcQb5SRx/+UCk
         ik5tNarW+gQNAwpz7mFUSsoy1NHekQ9dNVdrJkhg3NDIs3g607vV42F4aBxuOlJZMu84
         QiCM0Os7eldABa1Azm86khNByc7lQjPPvzWio=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 04/11]fs/nls/Kconfig Update broken web addresses.
Date: Fri, 10 Sep 2010 20:12:45 -0700
Message-Id: <1284174771-7033-4-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284174771-7033-1-git-send-email-justinmattock@gmail.com>
References: <1284174771-7033-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 fs/nls/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nls/Kconfig b/fs/nls/Kconfig
index a39edc4..83f617c 100644
--- a/fs/nls/Kconfig
+++ b/fs/nls/Kconfig
@@ -415,8 +415,8 @@ config NLS_ISO8859_14
 	  correctly on the screen, you need to include the appropriate
 	  input/output character sets. Say Y here for the Latin 8 character
 	  set, which adds the last accented vowels for Welsh (aka Cymraeg)
-	  (and Manx Gaelic) that were missing in Latin 1.
-	  <http://linux.speech.cymru.org/> has further information.
+	  (and Manx Gaelic) that were missing in Latin 1. For more info:
+	  <http://web.archive.org/web/*/http://linux.speech.cymru.org>.
 
 config NLS_ISO8859_15
 	tristate "NLS ISO 8859-15 (Latin 9; Western European Languages with Euro)"
-- 
1.7.2.1

