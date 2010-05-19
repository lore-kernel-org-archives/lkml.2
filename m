Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484Ab0ESPp7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 11:45:59 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:40981 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753254Ab0ESPp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 11:45:56 -0400
Date: Thu, 20 May 2010 01:45:54 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 08/17] davinci: update gfp/slab.h includes
Message-Id: <20100520014554.7bd9dbc6.sfr@canb.auug.org.au>
In-Reply-To: <1269885165-18617-9-git-send-email-tj@kernel.org>
References: <1269885165-18617-1-git-send-email-tj@kernel.org>
	<1269885165-18617-9-git-send-email-tj@kernel.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kevin,

On Tue, 30 Mar 2010 02:52:36 +0900 Tejun Heo <tj@kernel.org> wrote:
>
> Implicit slab.h inclusion via percpu.h is about to go away.  Make sure
> gfp.h or slab.h is included as necessary.

Please apply to the davinci tree (patch reposted below).

From: Tejun Heo <tj@kernel.org>
To: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Kevin Hilman <khilman@deeprootsystems.com>
Subject: [PATCH 08/17] davinci: update gfp/slab.h includes
Date: Tue, 30 Mar 2010 02:52:36 +0900

Implicit slab.h inclusion via percpu.h is about to go away.  Make sure
gfp.h or slab.h is included as necessary.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Kevin Hilman <khilman@deeprootsystems.com>
---
 drivers/rtc/rtc-davinci.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/rtc/rtc-davinci.c b/drivers/rtc/rtc-davinci.c
index 92a8f6c..34647fc 100644
--- a/drivers/rtc/rtc-davinci.c
+++ b/drivers/rtc/rtc-davinci.c
@@ -29,6 +29,7 @@
 #include <linux/bcd.h>
 #include <linux/platform_device.h>
 #include <linux/io.h>
+#include <linux/slab.h>
 
 /*
  * The DaVinci RTC is a simple RTC with the following
-- 
1.6.4.2

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
