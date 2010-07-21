Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933528Ab0GUE67 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 00:58:59 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:61571 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762265Ab0GUE54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:57:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=i8JZ5h1SEEIpH0e+ngr6EqqJVbjSRqkPOlS7Eg3/Mq6nViZv6jHzCpW2MvtF2EUqBP
         b/XwaD8/uzspyiVjJjeylWurs5Xn2mLRivf1l0sTNaur3VkflegjpRQn74/Xxsy+w0oI
         cebWZnbs1LcEI6Eii8IJk/62rn2ap+cIWAwok=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 108/108]Documentation/serial/moxa-smartio update web address.
Date: Tue, 20 Jul 2010 21:57:47 -0700
Message-Id: <1279688279-29683-3-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279688279-29683-1-git-send-email-justinmattock@gmail.com>
References: <1279688279-29683-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below updates a broken web address.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/serial/moxa-smartio |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/serial/moxa-smartio b/Documentation/serial/moxa-smartio
index 5337e80..d104439 100644
--- a/Documentation/serial/moxa-smartio
+++ b/Documentation/serial/moxa-smartio
@@ -76,7 +76,7 @@ Content
    GNU General Public License in this version. Please refer to GNU General
    Public License announcement in each source code file for more detail.
 
-   In Moxa's Web sites, you may always find latest driver at http://web.moxa.com.
+   In Moxa's Web sites, you may always find latest driver at http://www.moxa.com/.
 
    This version of driver can be installed as Loadable Module (Module driver)
    or built-in into kernel (Static driver). You may refer to following
-- 
1.7.1.rc1.21.gf3bd6

