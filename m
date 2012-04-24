Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305Ab2DXLXC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 07:23:02 -0400
Received: from gate.crashing.org ([63.228.1.57]:55212 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752288Ab2DXLXB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 07:23:01 -0400
Message-ID: <1335266570.15830.11.camel@pasglop>
Subject: Re: [PATCH v2 1/2] powerpc/8xx: Fix NR_IRQ bugs and refactor 8xx
 interrupt controller
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Date: Tue, 24 Apr 2012 21:22:50 +1000
In-Reply-To: <OF4123672B.F86C969F-ONC12579EA.002A2C1F-C12579EA.002A48C2@transmode.se>
References: <1335220202-32533-1-git-send-email-grant.likely@secretlab.ca>
	 <1335220202-32533-2-git-send-email-grant.likely@secretlab.ca>
	 <1335237195.24897.0.camel@pasglop>
	 <OF4123672B.F86C969F-ONC12579EA.002A2C1F-C12579EA.002A48C2@transmode.se>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-04-24 at 09:41 +0200, Joakim Tjernlund wrote:
> Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote on 2012/04/24 05:13:15:
> >
> > On Mon, 2012-04-23 at 16:30 -0600, Grant Likely wrote:
> > > The mpc8xx driver uses a reference to NR_IRQS that is buggy.  It uses
> > > NR_IRQs for the array size of the ppc_cached_irq_mask bitmap, but
> > > NR_IRQs could be smaller than the number of hardware irqs that
> > > ppc_cached_irq_mask tracks.
> >
> > Joakim, any chance you can test this ASAP ? :-)
> 
> Sorry, but no.  We have not moved our 8xx boards to 3.x as it in maintenance
> and takes too much space.

Ah ok... Anybody else on the list who still has some 8xx gear ?

Cheers,
Ben.


