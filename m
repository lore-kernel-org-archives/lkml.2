Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432Ab1HONeY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 09:34:24 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:56683 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753297Ab1HONeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 09:34:22 -0400
X-Authenticated: #41721828
X-Provags-ID: V01U2FsdGVkX1/lsdgeoFXlAdkuf2C6/UgBVhJNrP57KgzT3p5i8m
	TLv3q656dSNtxf
From: =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
To: linux-kernel@vger.kernel.org
Cc: Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        user-mode-linux-devel@lists.sourceforge.net, linux-doc@vger.kernel.org,
        =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
Subject: [PATCH] UserModeLinux-HOWTO.txt: fix a typo
Date: Mon, 15 Aug 2011 15:34:10 +0200
Message-Id: <1313415250-15428-1-git-send-email-j.neuschaefer@gmx.net>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jonathan Neuschäfer <j.neuschaefer@gmx.net>
---
 Documentation/virtual/uml/UserModeLinux-HOWTO.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/virtual/uml/UserModeLinux-HOWTO.txt b/Documentation/virtual/uml/UserModeLinux-HOWTO.txt
index a7af9cf..77dfecf 100644
--- a/Documentation/virtual/uml/UserModeLinux-HOWTO.txt
+++ b/Documentation/virtual/uml/UserModeLinux-HOWTO.txt
@@ -770,7 +770,7 @@
 
 
 
-  will cause serial line 3 to accept input on the host's /dev/tty3 and
+  will cause serial line 3 to accept input on the host's /dev/tty2 and
   display output on an xterm.  That's a silly example - the most common
   use of this syntax is to reattach the main console to stdin and stdout
   as shown above.
-- 
1.7.5.4

