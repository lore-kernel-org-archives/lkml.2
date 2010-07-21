Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762174Ab0GUFPi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 01:15:38 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:35617 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762103Ab0GUEyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:54:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=piGprRCyko6ZpEvJbM/D+00Qs2qKTdodQPpbuODR5qeiMORDkbtbY4sYzcoan6ThQZ
         CIyX42TYHlVEbrxJIJDTLCldp/J16NWSSC68EWuTiZRQgHHpsov8Siof5ZChA3HcwWrm
         kHhG/lLrAmz9TIrhk04Gq1Qnihmx91LI/vy/c=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 53/53]Documentation/ia64/serial.txt update web address.
Date: Tue, 20 Jul 2010 21:53:52 -0700
Message-Id: <1279688039-29465-8-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279688039-29465-1-git-send-email-justinmattock@gmail.com>
References: <1279688039-29465-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below updates a broken web address.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/ia64/serial.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/ia64/serial.txt b/Documentation/ia64/serial.txt
index 040b977..6869c73 100644
--- a/Documentation/ia64/serial.txt
+++ b/Documentation/ia64/serial.txt
@@ -133,7 +133,7 @@ TROUBLESHOOTING SERIAL CONSOLE PROBLEMS
 
 
 
-[1] http://www.dig64.org/specifications/DIG64_PCDPv20.pdf
+[1] http://www.dig64.org/specifications/agreement 
     The table was originally defined as the "HCDP" for "Headless
     Console/Debug Port."  The current version is the "PCDP" for
     "Primary Console and Debug Port Devices."
-- 
1.7.1.rc1.21.gf3bd6

