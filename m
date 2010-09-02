Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757236Ab0IBVGp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 17:06:45 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:39302 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757190Ab0IBVGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 17:06:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=g4bRaz8rPfI/eDaRNasdNjmeNj6yukaDZL6qi4rJQjLZ8ZR3wZ0cpAwxt3eKhG7mOV
         jhgDazB7N6OpH7eCUuWLwN+Q61J+76Fber4piXoPqFeIutH7N7uAF6NsIF2hzQlONNI3
         hiPou5LEjLqSNKkzb7RMq27Pq19NP6Xn4F2KY=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org, jkosina@suse.cz,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 03/91] arch/arm/plat-samsung/include/plat/adc.h Update broken web addresses in the arch directory.
Date: Thu,  2 Sep 2010 14:06:34 -0700
Message-Id: <1283461606-7803-4-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1283461606-7803-1-git-send-email-justinmattock@gmail.com>
References: <1283461606-7803-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below patch updates a broken web address that is no longer
working due to company buyout, and/or change of location.
(Please have a look through, and let me know if any of them
need to be changed, and I'll resend an updated patch).

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 arch/arm/plat-samsung/include/plat/adc.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/plat-samsung/include/plat/adc.h b/arch/arm/plat-samsung/include/plat/adc.h
index e8382c7..b258a08 100644
--- a/arch/arm/plat-samsung/include/plat/adc.h
+++ b/arch/arm/plat-samsung/include/plat/adc.h
@@ -1,7 +1,7 @@
 /* arch/arm/plat-samsung/include/plat/adc.h
  *
  * Copyright (c) 2008 Simtec Electronics
- *	http://armlinux.simnte.co.uk/
+ *	http://armlinux.simtec.co.uk/	
  *	Ben Dooks <ben@simtec.co.uk>
  *
  * S3C ADC driver information
-- 
1.7.2.1

