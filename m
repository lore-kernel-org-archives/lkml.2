Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762391Ab0GUFEM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 01:04:12 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64318 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933515Ab0GUE6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:58:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=VnUbbf/uym7emX+xLXYoJSymPKyY4JgOU0xP3J+gaxKjyOwOvVXLGudyyXhe18aq6q
         vd23GIOmWw6vLaGxGnWNYK1BdraAPtez9ulGEX/TzI4NyJ6B48vD+zPPVuH5M3VcA4Ne
         iZ6nycdmrXWrWkBhtL5m4tsM2fFIPUTnTDV7o=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 122/122]Documentation/video4linux/se401.txt update web address.
Date: Tue, 20 Jul 2010 21:58:39 -0700
Message-Id: <1279688336-29735-2-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279688336-29735-1-git-send-email-justinmattock@gmail.com>
References: <1279688336-29735-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below updates a broken web address.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/video4linux/se401.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/video4linux/se401.txt b/Documentation/video4linux/se401.txt
index 7b9d1c9..bd6526e 100644
--- a/Documentation/video4linux/se401.txt
+++ b/Documentation/video4linux/se401.txt
@@ -49,6 +49,6 @@ order to increase the throughput (and thus framerate).
 HELP:
 
 The latest info on this driver can be found at:
-http://www.chello.nl/~j.vreeken/se401/
+http://members.chello.nl/~j.vreeken/se401/
 And questions to me can be send to:
 pe1rxq@amsat.org
-- 
1.7.1.rc1.21.gf3bd6

