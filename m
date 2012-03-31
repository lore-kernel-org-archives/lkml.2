Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760Ab2CaUny (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 16:43:54 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:36499 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605Ab2CaUnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 16:43:49 -0400
Date: Sat, 31 Mar 2012 13:43:32 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Linas Vepstas <linasvepstas@gmail.com>, linux-kernel@vger.kernel.org,
        linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        uclinux-dist-devel@blackfin.uclinux.org, linux-hexagon@vger.kernel.org,
        linux-ia64@vger.kernel.org, linux-m32r@ml.linux-m32r.org,
        linux-m32r-ja@ml.linux-m32r.org, linux-mips@linux-mips.org,
        linux-am33-list@redhat.com, linux-parisc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        linux-sh@vger.kernel.org, sparclinux@vger.kernel.org,
        tglx@linutronix.de, linux@arm.linux.org.uk, dhowells@redhat.com,
        jejb@parisc-linux.org, linux390@de.ibm.com, x86@kernel.org,
        cmetcalf@tilera.com
Subject: Re: [PATCH RFC] Simplify the Linux kernel by reducing its state space
Message-ID: <20120331204332.GH2450@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120331163321.GA15809@linux.vnet.ibm.com>
 <20120331201500.GA27640@linas.org>
 <4F77681E.5010608@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F77681E.5010608@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12033120-4242-0000-0000-0000013678D7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 31, 2012 at 01:25:02PM -0700, Randy Dunlap wrote:
> On 03/31/2012 01:15 PM, Linas Vepstas wrote:
> 
> > 
> > Hi,
> > 
> > I didn't actually try to compile the patch below; it didn't look like
> > C code so I wasn't sure what compiler to run it through.  I guess maybe
> > its python?  However, I'm very sure that the patches are completely
> > correct, because I read them, and I also know Paul.  And I've heard of
> > Thomas Gleixner.
> 
> 
> x86_64 defconfig has many build errors and warnings.  :(

I suggest removing the code containing the errors and warnings.  I bet
that the offending code is not needed when running with zero CPUs.

> back to my abacus.

;-)

							Thanx, Paul

