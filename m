Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933662Ab0GUFCL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 01:02:11 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:47762 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933570Ab0GUE7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:59:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=dDeklqsEej6heVFOBvzAXXTq+cQgpaXkqhveC028ec9qFtmziXCNjKilUIoH2uVz12
         KppkJMQX/xtL21nXivOaj4at19CZ+TeEV4hnqtQZGgJr1w/F+LCZ7Nx+hN0Iewjnp3Ft
         6jpQKTJqSsXze9o1a7JgSggW9/rvREpUDZ51A=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 133/133]Documentation/video4linux/API.html update web address.
Date: Tue, 20 Jul 2010 21:58:50 -0700
Message-Id: <1279688336-29735-13-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279688336-29735-1-git-send-email-justinmattock@gmail.com>
References: <1279688336-29735-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below updates a broken web address.
Note: there another address for the V4L1 API but was unable
to locate an address.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/video4linux/API.html |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/video4linux/API.html b/Documentation/video4linux/API.html
index d749d41..d72fd2a 100644
--- a/Documentation/video4linux/API.html
+++ b/Documentation/video4linux/API.html
@@ -17,7 +17,7 @@
    </tr>
    <tr>
     <td>
-     <a href="http://www.linuxtv.org/downloads/video4linux/API/V4L2_API">V4L2 API</a>
+     <a href="http://v4l2spec.bytesex.org/spec-single/v4l2.html">V4L2 API</a>
     </td>
     <td>Should be used for new projects
     </td>
-- 
1.7.1.rc1.21.gf3bd6

