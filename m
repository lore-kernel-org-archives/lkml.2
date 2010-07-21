Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933385Ab0GUFOi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 01:14:38 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:35617 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab0GUEyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:54:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=FpHUTk7HvqvUAc1HUlgeNYPlnJ7ZagzjWlvA3LV7+Uv5Z/cyRhwPmdmsIfQZnf4X0a
         BNH05Z3wd1Q+7YjwaNHDvau4hc1wrpIj9+an3XZ3xSLO2NeQYaMHMS0JJnthcA9dX9vm
         LtfG84hoLzXxffTl2xUdvakxeWjW2uqaHsEjQ=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 60/60]Documentation/intel_txt.txt update web addresses.
Date: Tue, 20 Jul 2010 21:53:59 -0700
Message-Id: <1279688039-29465-15-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279688039-29465-1-git-send-email-justinmattock@gmail.com>
References: <1279688039-29465-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below patch updates the broken web addresses
to the best of my knowledge.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/intel_txt.txt |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/Documentation/intel_txt.txt b/Documentation/intel_txt.txt
index 5dc59b0..d025a19 100644
--- a/Documentation/intel_txt.txt
+++ b/Documentation/intel_txt.txt
@@ -25,14 +25,11 @@ which has been updated for the new released platforms.
 Intel TXT has been presented at various events over the past few
 years, some of which are:
       LinuxTAG 2008:
-          http://www.linuxtag.org/2008/en/conf/events/vp-donnerstag/
-          details.html?talkid=110
+          http://www.linuxtag.org/
       TRUST2008:
-          http://www.trust2008.eu/downloads/Keynote-Speakers/
-          3_David-Grawrock_The-Front-Door-of-Trusted-Computing.pdf
-      IDF 2008, Shanghai:
-          http://inteldeveloperforum.com.edgesuite.net/shanghai_2008/
-          aep/PROS003/index.html
+          http://www.trust-conference.eu/ 
+       IDF 2008, Shanghai:
+          http://intelstudios.edgesuite.net/090608_7871_fes/index.htm
       IDFs 2006, 2007 (I'm not sure if/where they are online)
 
 Trusted Boot Project Overview:
-- 
1.7.1.rc1.21.gf3bd6

