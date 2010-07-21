Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576Ab0GUExd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 00:53:33 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:47921 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755559Ab0GUExB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:53:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=xZYXZxamB13X4QWP5dLpJqbhWk/i6bSNwFYFi/a0nnT78WbEbUNILUtixK5LbEw8Pe
         CDXuwwlnVaXl0HuHYwP40j39bH8h+1zygv6PthGnaCa7zfmEkLeHOFnBM4w/IqOismcw
         uPz+3+avR41JmHXRFV5azlPBdPIHYEoGahNos=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 34/34]Documentation/filesystems/9p.txt update web address.
Date: Tue, 20 Jul 2010 21:52:51 -0700
Message-Id: <1279687982-29413-4-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279687982-29413-1-git-send-email-justinmattock@gmail.com>
References: <1279687982-29413-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below updates a broken web address.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/filesystems/9p.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/filesystems/9p.txt b/Documentation/filesystems/9p.txt
index c0236e7..29fda11 100644
--- a/Documentation/filesystems/9p.txt
+++ b/Documentation/filesystems/9p.txt
@@ -128,7 +128,7 @@ OPTIONS
 RESOURCES
 =========
 
-Our current recommendation is to use Inferno (http://www.vitanuova.com/inferno)
+Our current recommendation is to use Inferno (http://www.vitanuova.com/)
 as the 9p server.  You can start a 9p server under Inferno by issuing the
 following command:
    ; styxlisten -A tcp!*!564 export '#U*'
-- 
1.7.1.rc1.21.gf3bd6

