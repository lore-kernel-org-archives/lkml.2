Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762312Ab0GUFGe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 01:06:34 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:49232 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762291Ab0GUE6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:58:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=waEAX4ukN74L4D6nX+iAAaTOeMKcIg4Gj+rg4VNEFrX5l7H8n/8h6LrEWbC0MbVNpk
         VY5829pfwGDW5TcuOSTxFwNOi0aoes+6QXOY3mAXwhHtAXgckOOKjSyRbkaoVEBom4Ky
         oH+UMKPVNVwFdCssvWvHMofNF8aaQU6fI6BpY=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 114/114]Documentation/sound/oss/README.OSS update web address.
Date: Tue, 20 Jul 2010 21:57:53 -0700
Message-Id: <1279688279-29683-9-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279688279-29683-1-git-send-email-justinmattock@gmail.com>
References: <1279688279-29683-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below updates abroken web address, and removes a 
web address that is no longer available.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/sound/oss/README.OSS |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/Documentation/sound/oss/README.OSS b/Documentation/sound/oss/README.OSS
index fd42b05..c615deb 100644
--- a/Documentation/sound/oss/README.OSS
+++ b/Documentation/sound/oss/README.OSS
@@ -36,7 +36,7 @@ with OSS API.
 
 Packages "snd-util-3.8.tar.gz" and "snd-data-0.1.tar.Z"
 contain useful utilities to be used with this driver.
-See http://www.opensound.com/ossfree/getting.html for
+See http://www.opensound.com/ossfree/ for
 download instructions.
 
 If you are looking for the installation instructions, please
@@ -1438,7 +1438,7 @@ of this driver (see http://www.4Front-tech.com/oss.html for more info).
 There are some common audio chipsets that are not supported yet. For example
 Sierra Aria and IBM Mwave. It's possible that these architectures
 get some support in future but I can't make any promises. Just look
-at the home page (http://www.opensound.com/ossfree/new_cards.html)
+at the home page (http://www.opensound.com/ossfree/)
 for latest info.
 
 Information about unsupported sound cards and chipsets is welcome as well
@@ -1449,7 +1449,6 @@ If you have any corrections and/or comments, please contact me.
 Hannu Savolainen
 hannu@opensound.com
 
-Personal home page:	   http://www.compusonic.fi/~hannu
 home page of OSS/Free: http://www.opensound.com/ossfree
 
 home page of commercial OSS
-- 
1.7.1.rc1.21.gf3bd6

