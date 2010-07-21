Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755069Ab0GUEwk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 00:52:40 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:40697 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753518Ab0GUEv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:51:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=KjnPDmB3pNBoLcNdxzgPbIv5qSwvMeowi4970Ov9hhGe5QdqhBVRH9q/jo7I4w1DKy
         yMcBDGrtyurr2pWRKFEcLmreEOAdaWYpoZwwlPD1+DWnDcih5oW5FmqhD000CQxHedWm
         /Id1TJmZD2ZEpHibYQgc8tiv960b9I5yqnhRs=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 16/16]Documentation/binfmt_misc.txt update web address.
Date: Tue, 20 Jul 2010 21:51:52 -0700
Message-Id: <1279687926-29360-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below updates a broken web address to the company site
due to me being unable to locate the original content. If anybody
knows let me know and I'll resend this.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/binfmt_misc.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/binfmt_misc.txt b/Documentation/binfmt_misc.txt
index f609ebf..c1ed694 100644
--- a/Documentation/binfmt_misc.txt
+++ b/Documentation/binfmt_misc.txt
@@ -111,6 +111,6 @@ cause unexpected behaviour and can be a security hazard.
 
 
 There is a web page about binfmt_misc at
-http://www.tat.physik.uni-tuebingen.de/~rguenth/linux/binfmt_misc.html
+http://www.tat.physik.uni-tuebingen.de
 
 Richard Günther <rguenth@tat.physik.uni-tuebingen.de>
-- 
1.7.1.rc1.21.gf3bd6

