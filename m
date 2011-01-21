Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951Ab1AUHjn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 02:39:43 -0500
Received: from gate.crashing.org ([63.228.1.57]:51928 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882Ab1AUHjl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 02:39:41 -0500
Subject: Re: [patch 24/37] genirq: Remove __do_IRQ
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: David Howells <dhowells@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Richard Henderson <rth@twiddle.net>,
        Mike Frysinger <vapier@gentoo.org>, Tony Luck <tony.luck@intel.com>,
        Greg Ungerer <gerg@uclinux.org>, Michal Simek <monstr@monstr.eu>,
        Kyle McMartin <kyle@mcmartin.ca>,
        Chen Liqin <liqin.chen@sunplusct.com>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>, Jeff Dike <jdike@addtoit.com>
In-Reply-To: <10507.1295479158@redhat.com>
References: <20110119210840.041837065@linutronix.de>
	 <20110119205258.462759212@linutronix.de>  <10507.1295479158@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 21 Jan 2011 18:37:10 +1100
Message-ID: <1295595430.2148.286.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-19 at 23:19 +0000, David Howells wrote:
> Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > All architectures are finally converted. Remove the cruft.
> > 
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Richard Henderson <rth@twiddle.net>
> > Cc: Mike Frysinger <vapier@gentoo.org>
> > Cc: David Howells <dhowells@redhat.com>
> > Cc: Tony Luck <tony.luck@intel.com>
> > Cc: Greg Ungerer <gerg@uclinux.org>
> > Cc: Michal Simek <monstr@monstr.eu>
> > Cc: David Howells <dhowells@redhat.com>
> > Cc: Kyle McMartin <kyle@mcmartin.ca>
> > Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > Cc: Chen Liqin <liqin.chen@sunplusct.com>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: Chris Metcalf <cmetcalf@tilera.com>
> > Cc: Jeff Dike <jdike@addtoit.com>
> 
> Finally!

Yeah, Amen !

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Cheers,
Ben.


