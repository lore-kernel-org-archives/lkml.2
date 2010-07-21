Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821Ab0GUEvE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 00:51:04 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63473 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834Ab0GUEuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:50:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=IIn+cZNO8csQJsC5hkQTWq2utkdF26vSeX+5X166XBJhsETTTWsnJscX/h6MygyT4/
         1aHgpRtAWiSPEQHMZDHsmEkyEz9SGRGiRi+A2FToAmn6JRZU5qD0yDOffBdkeSBZw/Vm
         IXY4iZBR6zR0cP4qtOy6/X5PsWA+PdzTXt5SI=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 1/2]Documentation/ABI/testing/sysfs-devices-system-cpu update web address.
Date: Tue, 20 Jul 2010 21:50:47 -0700
Message-Id: <1279687861-29282-2-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279687861-29282-1-git-send-email-justinmattock@gmail.com>
References: <1279687861-29282-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below updates a broken web address.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/ABI/testing/sysfs-devices-system-cpu |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-devices-system-cpu b/Documentation/ABI/testing/sysfs-devices-system-cpu
index 84a710f..7564e88 100644
--- a/Documentation/ABI/testing/sysfs-devices-system-cpu
+++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
@@ -197,7 +197,7 @@ Description:	These files exist in every cpu's cache index directories.
 		Currently, only AMD Family 10h Processors support cache index
 		disable, and only for their L3 caches.  See the BIOS and
 		Kernel Developer's Guide at
-		http://www.amd.com/us-en/assets/content_type/white_papers_and_tech_docs/31116-Public-GH-BKDG_3.20_2-4-09.pdf
+		http://support.amd.com/us/Embedded_TechDocs/31116-Public-GH-BKDG_3-28_5-28-09.pdf	
 		for formatting information and other details on the
 		cache index disable.
 Users:    joachim.deguara@amd.com
-- 
1.7.1.rc1.21.gf3bd6

