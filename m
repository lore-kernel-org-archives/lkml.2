Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180Ab0IIQQ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 12:16:58 -0400
Received: from mail.perches.com ([173.55.12.10]:1556 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754887Ab0IIQQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 12:16:56 -0400
Subject: [PATCH] MAINTAINERS: Add IRQ SUBSYSTEM
From: Joe Perches <joe@perches.com>
To: Arthur Kepner <akepner@sgi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20100909155502.GB17836@sgi.com>
References: <20100903210554.GO2464@sgi.com>
	 <alpine.LFD.2.00.1009091050370.2477@localhost6.localdomain6>
	 <20100909155502.GB17836@sgi.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Sep 2010 09:16:53 -0700
Message-ID: <1284049013.24986.138.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-09 at 08:55 -0700, Arthur Kepner wrote:
> On Thu, Sep 09, 2010 at 10:54:50AM +0200, Thomas Gleixner wrote:
> > On Fri, 3 Sep 2010, Arthur Kepner wrote:
> > It might be helpful to cc the maintainer of kernel/irq on patches
> > which affect that area.
> It wasn't (and after reviewing the MAINTAINERS file, still isn't) 
> clear to me that you're the maintainer there, but I'll cc you on 
> this topic in the future.

To make it easier on others, maybe Thomas should add his name
to MAINTAINERS because kernel/irq currently has no listed MAINTAINER.

$ ./scripts/get_maintainer.pl --nogit --roles -f kernel/irq
linux-kernel@vger.kernel.org (open list)

$ ./scripts/get_maintainer.pl --git --rolestats -f kernel/irq
Thomas Gleixner <tglx@linutronix.de> (commit_signer:19/39=49%)
Jiri Kosina <jkosina@suse.cz> (commit_signer:5/39=13%)
"H. Peter Anvin" <hpa@zytor.com> (commit_signer:4/39=10%)
Yinghai Lu <yinghai@kernel.org> (commit_signer:4/39=10%)
Ingo Molnar <mingo@elte.hu> (commit_signer:3/39=8%)
linux-kernel@vger.kernel.org (open list)

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 087912a..1dd4c9f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3194,6 +3194,14 @@ F:	drivers/net/irda/
 F:	include/net/irda/
 F:	net/irda/
 
+IRQ SUBSYSTEM
+M:	Thomas Gleixner <tglx@linutronix.de>
+S:	Maintained
+F:	Documentation/IRQ*.txt
+F:	include/linux/interrupt.h
+F:	include/linux/irq.h
+F:	kernel/irq/
+
 ISAPNP
 M:	Jaroslav Kysela <perex@perex.cz>
 S:	Maintained


