Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871Ab1CVOjV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 10:39:21 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:48057 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944Ab1CVOjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 10:39:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=ft7hCN9VnutB3kpW5PeeBr7mfGPDsrHRkiV8j7oWcKKAF6bMoM7nox4RqCT3Xt99LZ
         Ilx+TYXApgXlDHOO/2C1Yw17/IdAgbOX1qN3+9Thdm8FM6bD86+Gf5Y+A2oLWGc/NSN2
         nw63YfutXSM7qhRu3hpYzAYWi3EalfIOfzcbA=
Date: Tue, 22 Mar 2011 22:38:43 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: zippel@linux-m68k.org, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: greg@kroah.com, joe@perches.com, akpm@linux-foundation.org
Subject: [PATCH]Clean up CodingStyle for scripts/kconfig/gconf.c
Message-ID: <20110322143839.GA10291@gmail.com>
Mail-Followup-To: zippel@linux-m68k.org, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, greg@kroah.com, joe@perches.com,
	akpm@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi us,
   	Clean up CodingStyle for scripts/kconfig/gconf.c.

Thanks.
Best Regards.
Harry Wei.

Signed-off-by: Harry Wei <harryxiyou@gmail.com>
---
 scripts/kconfig/gconf.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/kconfig/gconf.c b/scripts/kconfig/gconf.c
index 4558961..56da945 100644
--- a/scripts/kconfig/gconf.c
+++ b/scripts/kconfig/gconf.c
@@ -7,7 +7,7 @@
  */
 
 #ifdef HAVE_CONFIG_H
-#  include <config.h>
+#include <config.h>
 #endif
 
 #include "lkc.h"
-- 
1.7.0.4

