Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757585Ab0IBVIy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 17:08:54 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:51682 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757536Ab0IBVIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 17:08:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=j+9ef2zFUvif7yzjRFX3uOU1fsBvLu/Wk0vC3SDhkElKT/Ra5bP+7OTDWRlNqVzDrs
         SndZfTWNSOcxwzLvSa1vHbxIWNMNEaGda2UoslV1TTJ1dUBoaUX6HV1hFkq+SsAlt71b
         I97oh4Rcxaio77p3+SQ80dU1vrNI4JvP+E6XM=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org, jkosina@suse.cz,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 31/91] arch/ia64/sn/kernel/setup.c Update broken web addresses in the arch directory.
Date: Thu,  2 Sep 2010 14:08:52 -0700
Message-Id: <1283461746-7905-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below patch updates a broken web address that is no longer
working due to company buyout, and/or change of location.
(Please have a look through, and let me know if any of them
need to be changed, and I'll resend an updated patch).

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 arch/ia64/sn/kernel/setup.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/ia64/sn/kernel/setup.c b/arch/ia64/sn/kernel/setup.c
index dbc4cbe..a6723db 100644
--- a/arch/ia64/sn/kernel/setup.c
+++ b/arch/ia64/sn/kernel/setup.c
@@ -234,7 +234,8 @@ static void __cpuinit sn_check_for_wars(void)
  * Since pcdp support in SN is not supported in the 2.4 kernel (or at least
  * the one lbs is based on) just declare the needed structs here.
  *
- * Reference spec http://www.dig64.org/specifications/DIG64_PCDPv20.pdf
+ * Reference spec http://web.archive.org/web/*/http://www.dig64.org/
+ * specifications/DIG64_PCDPv20.pdf 
  *
  * Returns 0 if no acceptable vga is found, !0 otherwise.
  *
-- 
1.7.2.1

