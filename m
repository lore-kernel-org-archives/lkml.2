Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862Ab2GJGL5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 02:11:57 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:51884 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752347Ab2GJGL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 02:11:56 -0400
Date: Sun, 8 Jul 2012 14:17:07 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Kevin Hilman <khilman@ti.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 6/6] x86: Exit RCU extended QS on notify resume
Message-ID: <20120708211707.GG2522@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1341576018-10721-1-git-send-email-fweisbec@gmail.com>
 <1341576018-10721-7-git-send-email-fweisbec@gmail.com>
 <20120706163338.GW2522@linux.vnet.ibm.com>
 <20120706204329.GA9163@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120706204329.GA9163@leaf>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12071006-7282-0000-0000-00000AC0C59E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 06, 2012 at 01:43:29PM -0700, Josh Triplett wrote:
> On Fri, Jul 06, 2012 at 09:33:38AM -0700, Paul E. McKenney wrote:
> > On Fri, Jul 06, 2012 at 02:00:18PM +0200, Frederic Weisbecker wrote:
> > > --- a/arch/x86/Kconfig
> > > +++ b/arch/x86/Kconfig
> > > @@ -95,6 +95,7 @@ config X86
> > >  	select KTIME_SCALAR if X86_32
> > >  	select GENERIC_STRNCPY_FROM_USER
> > >  	select GENERIC_STRNLEN_USER
> > > +	select HAVE_RCU_USER_QS if X86_64
> > 
> > And I will bite yet again.  Why only 64-bit kernels?
> 
> Because HAVE_RCU_USER_QS requires an architecture-specific component,
> and this patch series only added the necessary bits to entry_64.S.

OK, please allow me to rephrase the question.  Why only entry_64.S?  ;-)

							Thanx, Paul

