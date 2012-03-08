Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526Ab2CHHsI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 02:48:08 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:46330 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918Ab2CHHsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 02:48:05 -0500
MIME-Version: 1.0
Date: Thu, 8 Mar 2012 15:48:03 +0800
Message-ID: <CAF8raN687u_PqzxS2kxNoQYO6mhO17u4eACE3fXuuRXN183Ggw@mail.gmail.com>
Subject: [PATCH] kbuild: incremental tags update for GNU Global
From: Jianbin Kang <kjbmail@gmail.com>
To: mmarek@suse.cz
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    GNU gtags support '-i' for updating tag files incrementally.
    It runs more quickly than generating new tags after kernel source update.

    Signed-off-by:  Jianbin Kang <kjbmail@gmail.com>
---
 scripts/tags.sh |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/tags.sh b/scripts/tags.sh
index 833813a..0bc8588 100755
--- a/scripts/tags.sh
+++ b/scripts/tags.sh
@@ -116,7 +116,7 @@ docscope()

 dogtags()
 {
-	all_sources | gtags -f -
+	all_sources | gtags -i -f -
 }

 exuberant()
