Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933439Ab0GUE5N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 00:57:13 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:62631 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756275Ab0GUE4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:56:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=nCL0Xy4sg1w8xmW65dYHVNLV8nieBOGqC9N80tqTCV+J5tMTpj0FIdpkHh2APmv/uF
         cPvPTeITvMH9xusnR1Lkz7P007jUWqWKWqeeQEHZWLah9w0lRsu3WGhl+tB5QvoeXEze
         xadddRNDsb4b877KtYmmOUb7lk+Wym4JGaq/Q=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 82/82]Documentation/networking/s2io.txt update wbe address.
Date: Tue, 20 Jul 2010 21:55:45 -0700
Message-Id: <1279688153-29571-7-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279688153-29571-1-git-send-email-justinmattock@gmail.com>
References: <1279688153-29571-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below updates abroken web address.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/networking/s2io.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/networking/s2io.txt b/Documentation/networking/s2io.txt
index c3d6b4d..dea193a 100644
--- a/Documentation/networking/s2io.txt
+++ b/Documentation/networking/s2io.txt
@@ -133,7 +133,7 @@ bring down CPU utilization.
 ** For AMD opteron platforms with 8131 chipset, MMRBC=1 and MOST=1 are 
 recommended as safe parameters.
 For more information, please review the AMD8131 errata at
-http://www.amd.com/us-en/assets/content_type/white_papers_and_tech_docs/26310.pdf
+http://www.amd.com
 
 6.  Available Downloads
 Neterion "s2io" driver in Red Hat and Suse 2.6-based distributions is kept up 
-- 
1.7.1.rc1.21.gf3bd6

