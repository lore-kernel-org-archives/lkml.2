Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933281Ab0GUEzc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 00:55:32 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42452 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762134Ab0GUEyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:54:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Z9VMb10GpzX1FdwJu/9+UrDuj7W5/Vs92kGBPCEDhpb8R1ilpGQ/YZRJzQBKN44IxY
         jwMv6nZpKCHmuERhMVM5jLmUZYjDOY9JuOCBUF8THspkpTdE/mv2ML4bIRI19k5rutVh
         iFK630DBrHy5CSgpv7/ifqUP4al7ZaUpK0Vfo=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 59/59]Documentation/input/sentelic.txt update web address.
Date: Tue, 20 Jul 2010 21:53:58 -0700
Message-Id: <1279688039-29465-14-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279688039-29465-1-git-send-email-justinmattock@gmail.com>
References: <1279688039-29465-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below updates a broken web address.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/input/sentelic.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/input/sentelic.txt b/Documentation/input/sentelic.txt
index b35affd..b2ef125 100644
--- a/Documentation/input/sentelic.txt
+++ b/Documentation/input/sentelic.txt
@@ -341,7 +341,7 @@ Byte 5~8: Don't care (Absolute packet)
 FSP supports basic PS/2 commanding set and modes, refer to following URL for
 details about PS/2 commands:
 
-http://www.computer-engineering.org/index.php?title=PS/2_Mouse_Interface
+http://www.computer-engineering.org/ps2mouse/
 
 ==============================================================================
 * Programming Sequence for Determining Packet Parsing Flow
-- 
1.7.1.rc1.21.gf3bd6

