Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806Ab1FJRDx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 13:03:53 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47440 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316Ab1FJRDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 13:03:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=cXP5nKagBOzFtlMCz6p+r7zidNK2vkMip0I9f1gtCh+U6lSmyCcQjzdczpr/w8NXib
         73HF2ridoQbTszZPAOFWjDwNWgyqS7fsHnZeN/g41ovi5ej2Y2JkElwxbJTGs+9vc4sX
         uCvpsmR1LogFU1D21xvAEeRRhpXsAtXHsKOog=
Subject: [BUGFIX] [PATCH] APM: Dynamic select of APM_CPU_IDLE on APM
 enabling.
From: Vitaliy Ivanov <vitalivanov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: hilld@binarystorm.net, apmbugs@rothwell.emu.id.au, vitalivanov@gmail.com
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Jun 2011 20:03:45 +0300
Message-ID: <1307725425.4266.23.camel@vivanov>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Bug fix for #36902:
https://bugzilla.kernel.org/show_bug.cgi?id=36902

I saw email about removing APM completely but as of now we can add the following to close build issue.
---

Dynamic select of APM_CPU_IDLE feature for enabling APM.

Signed-off-by: Vitaliy Ivanov <vitalivanov@gmail.com>

>From f00634bec035f1526266340bf75aa4e2620c8284 Mon Sep 17 00:00:00 2001
From: Vitaliy Ivanov <vitalivanov@gmail.com>
Date: Fri, 10 Jun 2011 19:06:37 +0300
Subject: [PATCH] Dynamic select of APM_CPU_IDLE on APM enabling.

---
 arch/x86/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index da34972..3c9b459 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1721,6 +1721,7 @@ config X86_APM_BOOT
 
 menuconfig APM
 	tristate "APM (Advanced Power Management) BIOS support"
+	select APM_CPU_IDLE
 	depends on X86_32 && PM_SLEEP
 	---help---
 	  APM is a BIOS specification for saving power using several different
-- 
1.7.0.4



