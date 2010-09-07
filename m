Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755762Ab0IGDnO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 23:43:14 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:64687 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754877Ab0IGDmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 23:42:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=stNyktOYeINiEMFacH6FC3Vvcek5fFQptAIBRbwsn2DpYgAtefMi3jwFhDeQ76/tyb
         xJy1shBaZBVfnjgxaCdqpdo3NGxtMOCsyjR/StJu4oqaResp0nHnYLq9jCs3qxAaOzzG
         pJ8Ohmc5o7LJ73Azqlty0Q5OJ0crdVxuP/17A=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 4/4] Documentation/networking/s2io.txt Fix web address to one line instead of two.
Date: Mon,  6 Sep 2010 20:43:00 -0700
Message-Id: <1283830980-25750-4-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1283830980-25750-1-git-send-email-justinmattock@gmail.com>
References: <1283830980-25750-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As mentioned in other posts, it's better to just have the web address
as one long line instead of broken into two lines.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/networking/s2io.txt |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/s2io.txt b/Documentation/networking/s2io.txt
index 9d4e0f4..be12fa5 100644
--- a/Documentation/networking/s2io.txt
+++ b/Documentation/networking/s2io.txt
@@ -133,8 +133,7 @@ bring down CPU utilization.
 ** For AMD opteron platforms with 8131 chipset, MMRBC=1 and MOST=1 are 
 recommended as safe parameters.
 For more information, please review the AMD8131 errata at
-http://vip.amd.com/us-en/assets/content_type/white_papers_and_tech_docs/
-26310_AMD-8131_HyperTransport_PCI-X_Tunnel_Revision_Guide_rev_3_18.pdf
+http://vip.amd.com/us-en/assets/content_type/white_papers_and_tech_docs/26310_AMD-8131_HyperTransport_PCI-X_Tunnel_Revision_Guide_rev_3_18.pdf
 
 6.  Available Downloads
 Neterion "s2io" driver in Red Hat and Suse 2.6-based distributions is kept up 
-- 
1.7.2.1

