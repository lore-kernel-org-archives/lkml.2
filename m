Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934070Ab1CXT2X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 15:28:23 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:63376 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933988Ab1CXT2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 15:28:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=dmxUPnpgaxoHBrsfvVBSxrtb6XTP1Bu/mrsLvDIZW2NznEvVAf27/VNNMxprs7Jq+0
         YZHgtqW3dMLDPqYVkKgZMPW7O0vpdU3NltXPC1qh0oEIPZ6vima15OEyFRpmgAbRy1Ky
         XovijKlGykAzDB/cXZwBP34VW1cxWsy5ykaO8=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [RFC 21/21]tools:power:x86:turbostat:turbostat.c Remove extra comma.
Date: Thu, 24 Mar 2011 12:26:59 -0700
Message-Id: <1300994819-30930-21-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300994819-30930-1-git-send-email-justinmattock@gmail.com>
References: <1300994819-30930-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes an extra comma from various parts 
of the kernel. Please have a look when you have time, and let
me know if its legit or not.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 tools/power/x86/turbostat/turbostat.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index 362a0cb..6d8ef4a 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -990,7 +990,7 @@ int fork_it(char **argv)
 	if (!retval)
 		print_counters(cnt_delta);
 
-	fprintf(stderr, "%.6f sec\n", tv_delta.tv_sec + tv_delta.tv_usec/1000000.0);;
+	fprintf(stderr, "%.6f sec\n", tv_delta.tv_sec + tv_delta.tv_usec/1000000.0);
 
 	return 0;
 }
-- 
1.7.4.1

