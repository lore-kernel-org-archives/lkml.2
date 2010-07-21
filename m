Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933709Ab0GUFVe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 01:21:34 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:40697 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753791Ab0GUEwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:52:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=HDqGYfcdbK+jj0cdeNt76j1UW32xskd1UiXt8wmkWIuVrHMZvdOVSRNwuHGge3p9DL
         gcjy8QEHFxl/ANWnRnYuN6PJqZ/OzlIGSTZ9tlXZsvaMfAjpHfe+XQ0Y/TdWI/Fl+yow
         okf+iGlCQ8rCDPrZzFtbfKw64Caf2e0lG9R+U=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 19/19]Documentation/cgroups/cpusets.txt fix typo in web address.
Date: Tue, 20 Jul 2010 21:51:55 -0700
Message-Id: <1279687926-29360-4-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279687926-29360-1-git-send-email-justinmattock@gmail.com>
References: <1279687926-29360-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below patch fixes a typo that breaks the location to the
web address.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/cgroups/cpusets.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/cgroups/cpusets.txt b/Documentation/cgroups/cpusets.txt
index 51682ab..5d0d569 100644
--- a/Documentation/cgroups/cpusets.txt
+++ b/Documentation/cgroups/cpusets.txt
@@ -691,7 +691,7 @@ There are ways to query or modify cpusets:
    cat, rmdir commands from the shell, or their equivalent from C.
  - via the C library libcpuset.
  - via the C library libcgroup.
-   (http://sourceforge.net/proects/libcg/)
+   (http://sourceforge.net/projects/libcg/)
  - via the python application cset.
    (http://developer.novell.com/wiki/index.php/Cpuset)
 
-- 
1.7.1.rc1.21.gf3bd6

