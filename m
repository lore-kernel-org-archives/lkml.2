Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934219Ab1CXUTh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 16:19:37 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:51040 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934200Ab1CXUT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 16:19:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=a6yhdBHUfQHW498WaTsrbtVIuy5+PIz0I/NA1G1YQn/KruNbtZO0XKxxirpTgWfO8x
         J23rbPZmmjZcbFgXcBfUuI09PSzQR7mnpxWj6FUIUE24aKEAMQ8p8ue2P9a98Gq0vhF9
         uwnnHEjPGigw44exMfxL4xGy6jZWnI7+UHUE4=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [RFC V2 21/21]tools:power:x86:turbostat:turbostat.c Remove extra semi-colon.
Date: Thu, 24 Mar 2011 13:18:40 -0700
Message-Id: <1300997920-31573-21-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300997920-31573-1-git-send-email-justinmattock@gmail.com>
References: <1300997920-31573-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes an extra semi-colon from various parts 
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

