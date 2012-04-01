Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843Ab2DASLl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 14:11:41 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:45022 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418Ab2DASLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 14:11:37 -0400
Date: Sun, 1 Apr 2012 11:11:15 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
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
Message-ID: <20120401181114.GY2450@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120331163321.GA15809@linux.vnet.ibm.com>
 <20120401100448.GD14848@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120401100448.GD14848@liondog.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12040118-6148-0000-0000-000004B8C6C6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 01, 2012 at 12:04:48PM +0200, Borislav Petkov wrote:
> On Sun, Apr 01, 2012 at 12:33:21AM +0800, Paul E. McKenney wrote:
> > Although there have been numerous complaints about the complexity of
> > parallel programming (especially over the past 5-10 years), the plain
> > truth is that the incremental complexity of parallel programming over
> > that of sequential programming is not as large as is commonly believed.
> > Despite that you might have heard, the mind-numbing complexity of modern
> > computer systems is not due so much to there being multiple CPUs, but
> > rather to there being any CPUs at all.  In short, for the ultimate in
> > computer-system simplicity, the optimal choice is NR_CPUS=0.
> > 
> > This commit therefore limits kernel builds to zero CPUs.  This change
> > has the beneficial side effect of rendering all kernel bugs harmless.
> > Furthermore, this commit enables additional beneficial changes, for
> > example, the removal of those parts of the kernel that are not needed
> > when there are zero CPUs.
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
> 
> Looks good, thanks for doing that.
> 
> Btw, I just got confirmation from hw folk that we can actually give you
> hardware support for that code with an upcoming CPU which has NR_CPUS=0
> cores.
> 
> Oh, and additionally, we can disable some of those so getting into the
> negative is also doable from the hw perspective, so feel free to explore
> that side of the problem too.
> 
> ACK.

Cute!  ;-)

							Thanx, Paul

