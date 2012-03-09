Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228Ab2CIDOL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 22:14:11 -0500
Received: from gate.crashing.org ([63.228.1.57]:39429 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753575Ab2CIDOJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 22:14:09 -0500
Message-ID: <1331262821.3105.47.camel@pasglop>
Subject: Re: linux-next: manual merge of the powerpc tree with the arm tree
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Russell King <rmk@arm.linux.org.uk>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Michael Neuling <mikey@neuling.org>, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>
Date: Fri, 09 Mar 2012 14:13:41 +1100
In-Reply-To: <20120309003937.GC8680@flint.arm.linux.org.uk>
References: <20120308120422.e071cba36425eacbee1f8d98@canb.auug.org.au>
	 <25744.1331174036@neuling.org>
	 <20120308145131.fad50bbc79c36f0b0b12d101@canb.auug.org.au>
	 <1331185951.3105.29.camel@pasglop> <1331249746.3105.40.camel@pasglop>
	 <20120309003937.GC8680@flint.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-03-09 at 00:39 +0000, Russell King wrote:
> On Fri, Mar 09, 2012 at 10:35:46AM +1100, Benjamin Herrenschmidt wrote:
> > Actually, I didn't keep MAY_HAVE_SPARSE_IRQ, I kept HAVE_SPARSE_IRQ. If
> > I remove it, then I get Kconfig warnings:
> > 
> > warning: (PPC) selects SPARSE_IRQ which has unmet direct dependencies
> > (HAVE_GENERIC_HARDIRQS && HAVE_SPARSE_IRQ)
> 
> Do you have commit 2ed86b16eabe4efbf80cc725a8cbb5310746a2fc ?

Nope, Grant patch didn't mention a dependency.

Cheers,
Ben.


