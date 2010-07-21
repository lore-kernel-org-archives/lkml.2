Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762478Ab0GUFLG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 01:11:06 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:62631 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762222Ab0GUE4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:56:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=qSl0CSCAkwFCKt/ZmgD9ND4HhP873xLAHr1HKYVa1h8OPg9O9i9mYu7+d21C19RNbg
         DyZLz8Tdx0xQRu41a3PtgatoN7C0PjsQEjwSg07qQ/3TUI6+G638bGG/eK9BWPPNd2nH
         zvJqvngH2+aT1H//xSEKNAOmGdhOF2Dc4SZGc=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 84/84]Documentation/networking/ipddp.txt update web address.
Date: Tue, 20 Jul 2010 21:55:47 -0700
Message-Id: <1279688153-29571-9-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279688153-29571-1-git-send-email-justinmattock@gmail.com>
References: <1279688153-29571-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes an unused web address. if anybody
knows the location for this let me know.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/networking/ipddp.txt |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/Documentation/networking/ipddp.txt b/Documentation/networking/ipddp.txt
index 661a555..ba5c217 100644
--- a/Documentation/networking/ipddp.txt
+++ b/Documentation/networking/ipddp.txt
@@ -36,11 +36,6 @@ AppleTalk-IP to IP decapsulation.
 Basic instructions for user space tools
 =======================================
 
-To enable AppleTalk-IP decapsulation/encapsulation you will need the 
-proper tools. You can get the tools for decapsulation from
-http://spacs1.spacs.k12.wi.us/~jschlst/index.html and for encapsulation
-from http://www.maths.unm.edu/~bradford/ltpc.html
-
 I will briefly describe the operation of the tools, but you will
 need to consult the supporting documentation for each set of tools.
 
-- 
1.7.1.rc1.21.gf3bd6

