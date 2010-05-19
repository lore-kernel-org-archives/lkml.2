Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739Ab0ESP4r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 11:56:47 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:45699 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753745Ab0ESP4p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 11:56:45 -0400
Date: Thu, 20 May 2010 01:56:43 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 17/17] arm: update gfp/slab.h includes
Message-Id: <20100520015643.d94636c0.sfr@canb.auug.org.au>
In-Reply-To: <1269885165-18617-18-git-send-email-tj@kernel.org>
References: <1269885165-18617-1-git-send-email-tj@kernel.org>
	<1269885165-18617-18-git-send-email-tj@kernel.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

On Tue, 30 Mar 2010 02:52:45 +0900 Tejun Heo <tj@kernel.org> wrote:
>
> Implicit slab.h inclusion via percpu.h is about to go away.  Make sure
> gfp.h or slab.h is included as necessary.

Please apply to the arm tree (patch reposted below).

From: Tejun Heo <tj@kernel.org>
To: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Russell King <linux@arm.linux.org.uk>
Subject: [PATCH 17/17] arm: update gfp/slab.h includes
Date: Tue, 30 Mar 2010 02:52:45 +0900

Implicit slab.h inclusion via percpu.h is about to go away.  Make sure
gfp.h or slab.h is included as necessary.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Russell King <linux@arm.linux.org.uk>
---
 arch/arm/mach-vexpress/ct-ca9x4.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-vexpress/ct-ca9x4.c b/arch/arm/mach-vexpress/ct-ca9x4.c
index 5a0449c..b4b0bb4 100644
--- a/arch/arm/mach-vexpress/ct-ca9x4.c
+++ b/arch/arm/mach-vexpress/ct-ca9x4.c
@@ -2,6 +2,7 @@
  * Versatile Express Core Tile Cortex A9x4 Support
  */
 #include <linux/init.h>
+#include <linux/gfp.h>
 #include <linux/device.h>
 #include <linux/dma-mapping.h>
 #include <linux/platform_device.h>
-- 
1.6.4.2

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
