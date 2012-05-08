Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986Ab2EHSUx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 14:20:53 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:45137 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087Ab2EHSUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 14:20:50 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 108.17.144.84
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX182oCY6W36jm0hYbKroNfhJKuUqvDPFUVU=
Date: Tue, 8 May 2012 14:20:26 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Ian Campbell <ijc@hellion.org.uk>, Sergei Shtylyov <sshtylyov@mvista.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: kirkwood: add missing kexec.h include
Message-ID: <20120508182026.GF15711@titan.lakedaemon.net>
References: <1335706842-11725-1-git-send-email-ijc@hellion.org.uk>
 <201204301421.45446.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201204301421.45446.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2012 at 02:21:45PM +0000, Arnd Bergmann wrote:
> On Sunday 29 April 2012, Ian Campbell wrote:
> > 
> > Fixes the following build error when CONFIG_KEXEC is enabled:
> >   CC      arch/arm/mach-kirkwood/board-dt.o
> > arch/arm/mach-kirkwood/board-dt.c: In function 'kirkwood_dt_init':
> > arch/arm/mach-kirkwood/board-dt.c:52:2: error: 'kexec_reinit' undeclared (first use in this function)
> > arch/arm/mach-kirkwood/board-dt.c:52:2: note: each undeclared identifier is reported only once for each function it appears in
> > 
> > Signed-off-by: Ian Campbell <ijc@hellion.org.uk>
> > [v4, rebase onto recent Linus for repost]
> > [v3, speak actual English in the commit message, thanks Sergei Shtylyov]
> > [v2, using linux/kexec.h not asm/kexec.h]
> 
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> 
> Jason, can you apply this patch on your tree?

Got it, putting together a branch for v3.4 fixes now.

thx,

Jason.
