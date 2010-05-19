Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133Ab0ESPiW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 11:38:22 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:41086 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751826Ab0ESPiS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 11:38:18 -0400
Date: Thu, 20 May 2010 01:38:16 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Joel Becker <joel.becker@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 04/17] ocfs2: update gfp/slab.h includes
Message-Id: <20100520013816.0779e351.sfr@canb.auug.org.au>
In-Reply-To: <1269885165-18617-5-git-send-email-tj@kernel.org>
References: <1269885165-18617-1-git-send-email-tj@kernel.org>
	<1269885165-18617-5-git-send-email-tj@kernel.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joel,

On Tue, 30 Mar 2010 02:52:32 +0900 Tejun Heo <tj@kernel.org> wrote:
>
> Implicit slab.h inclusion via percpu.h is about to go away.  Make sure
> gfp.h or slab.h is included as necessary.

Please apply to the ocfs2 tree (patch reposted below).

From: Tejun Heo <tj@kernel.org>
To: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Joel Becker <joel.becker@oracle.com>
Subject: [PATCH 04/17] ocfs2: update gfp/slab.h includes
Date: Tue, 30 Mar 2010 02:52:32 +0900

Implicit slab.h inclusion via percpu.h is about to go away.  Make sure
gfp.h or slab.h is included as necessary.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/reservations.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/reservations.c b/fs/ocfs2/reservations.c
index 7fc6cfe..ed59559 100644
--- a/fs/ocfs2/reservations.c
+++ b/fs/ocfs2/reservations.c
@@ -26,7 +26,6 @@
 
 #include <linux/fs.h>
 #include <linux/types.h>
-#include <linux/slab.h>
 #include <linux/highmem.h>
 #include <linux/bitops.h>
 #include <linux/list.h>
-- 
1.6.4.2

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
