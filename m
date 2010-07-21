Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762183Ab0GUEzH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 00:55:07 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:32789 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762114Ab0GUEyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:54:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Ej2YiprlyTyKo3T4fsgsWkcnQvfRhU33pMbJpoBQrtpJ+0JTCFXzO6vqv60+FEBA3c
         BReYjLR2wIru420JFRlZEfGQAWHcHjN5mVIGnZPxqmY0u22BRTAyGmVYYUhAZu7TYbL3
         jr7mZfUNX72kvRhreOfAH2SaHCqQqv9+sIjRI=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 55/55]Documentation/input/bcm5974.txt fix typo.
Date: Tue, 20 Jul 2010 21:53:54 -0700
Message-Id: <1279688039-29465-10-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279688039-29465-1-git-send-email-justinmattock@gmail.com>
References: <1279688039-29465-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Th epatch below fixes a typo in the web address causing it to be broken.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/input/bcm5974.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/input/bcm5974.txt b/Documentation/input/bcm5974.txt
index 5e22dcf..74d3876 100644
--- a/Documentation/input/bcm5974.txt
+++ b/Documentation/input/bcm5974.txt
@@ -62,4 +62,4 @@ Links
 -----
 
 [1] http://ubuntuforums.org/showthread.php?t=840040
-[2] http://http://bitmath.org/code/
+[2] http://bitmath.org/code/
-- 
1.7.1.rc1.21.gf3bd6

