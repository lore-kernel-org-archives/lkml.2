Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932780Ab0EJX1A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:27:00 -0400
Received: from kroah.org ([198.145.64.141]:33440 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932563Ab0EJWxF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:53:05 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:33:27 2010
Message-Id: <20100510223327.400112847@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:33:22 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Daniel Mack <daniel@caiaq.de>,
       Jakob Viketoft <jakob.viketoft@bitsim.com>,
       Eric Miao <eric.y.miao@gmail.com>
Subject: [111/117] [ARM] pxa/colibri: fix missing #include <mach/mfp.h> in colibri.h
In-Reply-To: <20100510223700.GA18404@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jakob Viketoft <jakob.viketoft@bitsim.com>

commit ccb8d8d070b8f25f0163da5c9ceacf63a5169540 upstream.

The use of mfp_cfg_t causes build errors without including <mach/mfp.h>.

CC: Daniel Mack <daniel@caiaq.de>
Signed-off-by: Jakob Viketoft <jakob.viketoft@bitsim.com>
Signed-off-by: Eric Miao <eric.y.miao@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/arm/mach-pxa/include/mach/colibri.h |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm/mach-pxa/include/mach/colibri.h
+++ b/arch/arm/mach-pxa/include/mach/colibri.h
@@ -2,6 +2,7 @@
 #define _COLIBRI_H_
 
 #include <net/ax88796.h>
+#include <mach/mfp.h>
 
 /*
  * common settings for all modules


