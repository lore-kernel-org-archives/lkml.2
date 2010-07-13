Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033Ab0GMJtk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 05:49:40 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53765 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755955Ab0GMJti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 05:49:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:content-type:date:message-id
         :mime-version:x-mailer:content-transfer-encoding;
        b=qLwjAnJUC7BW+2nRL51/F/5wiwnDn03ubVwrbtq+v38nJpfXzjxq3T5d234rmZzg7Z
         9j+M4MZLxupf0HZ1kffqDBl6ssYvmfJpkQmZnBOn7rDLg9jlC9rw7UfN5uRl0wLc1kWC
         1SUB7pvvqohT88uoBHcBzLbsEkhroBWj//g0c=
Subject: [PATCH RESEND padmux.c] Fix typo in kerneldoc
From: Davidlohr Bueso <dave.bueso@gmail.com>
Reply-To: dave.bueso@gmail.com
To: viresh.kumar@st.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        trivial@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Jul 2010 05:49:21 -0400
Message-ID: <1279014561.18280.0.camel@cowboy>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trivial fix in a typo (enalbed for enabled).

Thanks,
Davidlohr


Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 arch/arm/plat-spear/padmux.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/plat-spear/padmux.c b/arch/arm/plat-spear/padmux.c
index d2aab3a..555eec6 100644
--- a/arch/arm/plat-spear/padmux.c
+++ b/arch/arm/plat-spear/padmux.c
@@ -66,7 +66,7 @@ static int pmx_mode_set(struct pmx_mode *mode)
  * If peripheral is not supported by current mode then request is rejected.
  * Conflicts between peripherals are not handled and peripherals will be
  * enabled in the order they are present in pmx_dev array.
- * In case of conflicts last peripheral enalbed will be present.
+ * In case of conflicts last peripheral enabled will be present.
  * Returns -ve on Err otherwise 0
  */
 static int pmx_devs_enable(struct pmx_dev **devs, u8 count)
-- 
1.7.0.4




