Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762342Ab0GUFMb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 01:12:31 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:37757 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476Ab0GUEzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:55:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=QPqYcFcubodTs7BytcPlLo2Td22qF/G9yH2ZNsT3oT907ufPrU/dhlvDtacdmEfc/L
         JklQBGArK+hVeApu4lVGwcOcXVeCLDwZxrkUtndHFXZly5bkNCA7uuikdHJNCpfLwzn4
         sbmjUuPrABZG4dKKVeVHyfjtCLOWomJtctiy0=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 75/75]Documentation/networking/decnet.txt update web address.
Date: Tue, 20 Jul 2010 21:54:56 -0700
Message-Id: <1279688096-29519-15-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279688096-29519-1-git-send-email-justinmattock@gmail.com>
References: <1279688096-29519-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below updates a broken web address.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/networking/decnet.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/networking/decnet.txt b/Documentation/networking/decnet.txt
index d896895..9300257 100644
--- a/Documentation/networking/decnet.txt
+++ b/Documentation/networking/decnet.txt
@@ -4,7 +4,7 @@
 1) Other documentation....
 
    o Project Home Pages
-       http://www.chygwyn.com/DECnet/                      - Kernel info
+       http://www.chygwyn.com/                      	    - Kernel info
        http://linux-decnet.sourceforge.net/                - Userland tools
        http://www.sourceforge.net/projects/linux-decnet/   - Status page
 
-- 
1.7.1.rc1.21.gf3bd6

