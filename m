Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108Ab0ESPm3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 11:42:29 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:40911 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752351Ab0ESPm1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 11:42:27 -0400
Date: Thu, 20 May 2010 01:42:25 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Gregory Haskins" <ghaskins@novell.com>
Cc: "Tejun Heo" <tj@kernel.org>, <linux-kernel@vger.kernel.org>,
       <linux-next@vger.kernel.org>
Subject: Re: [PATCH 06/17] vbus: update gfp/slab.h includes
Message-Id: <20100520014225.e4343903.sfr@canb.auug.org.au>
In-Reply-To: <4BB2FF000200005A0006349E@soto.provo.novell.com>
References: <1269885165-18617-1-git-send-email-tj@kernel.org>
	<1269885165-18617-7-git-send-email-tj@kernel.org>
	<4BB2FF000200005A0006349E@soto.provo.novell.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gregory,

On Wed, 31 Mar 2010 05:51:28 -0600 "Gregory Haskins" <ghaskins@novell.com> wrote:
>
> >>> On 3/29/2010 at 01:52 PM, in message
> <1269885165-18617-7-git-send-email-tj@kernel.org>, Tejun Heo <tj@kernel.org>
> wrote: 
> > Implicit slab.h inclusion via percpu.h is about to go away.  Make sure
> > gfp.h or slab.h is included as necessary.
> > 
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> > Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> > Cc: Gregory Haskins <ghaskins@novell.com>
> 
> Thanks Tejun,
> 
> Acked-by: Gregory Haskins <ghaskins@novell.com>
> 
> (will add to my tree)

It never made it as far as I can see ... maybe something equivalent went in.

From: Tejun Heo <tj@kernel.org>
To: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 06/17] vbus: update gfp/slab.h includes
Date: Tue, 30 Mar 2010 02:52:34 +0900

Implicit slab.h inclusion via percpu.h is about to go away.  Make sure
gfp.h or slab.h is included as necessary.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Gregory Haskins <ghaskins@novell.com>
---
 drivers/vbus/pci-bridge.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/vbus/pci-bridge.c b/drivers/vbus/pci-bridge.c
index 0d51324..36de7c4 100644
--- a/drivers/vbus/pci-bridge.c
+++ b/drivers/vbus/pci-bridge.c
@@ -22,6 +22,7 @@
 #include <linux/pci.h>
 #include <linux/mm.h>
 #include <linux/workqueue.h>
+#include <linux/slab.h>
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
 #include <linux/ioq.h>
-- 
1.6.4.2

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
