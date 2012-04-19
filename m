Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226Ab2DSSVh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 14:21:37 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:64605 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753919Ab2DSSVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 14:21:36 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 2/2] irqdomain/powerpc: Fix broken NR_IRQ references
To: Michael Ellerman <michael@ellerman.id.au>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
In-Reply-To: <1334796301.6791.9.camel@concordia>
References: <1334607198-18694-1-git-send-email-grant.likely@secretlab.ca> <1334607198-18694-2-git-send-email-grant.likely@secretlab.ca> <1334796301.6791.9.camel@concordia>
Date: Thu, 19 Apr 2012 12:21:33 -0600
Message-Id: <20120419182133.7B50F3E0700@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Apr 2012 10:45:01 +1000, Michael Ellerman <michael@ellerman.id.au> wrote:
> On Mon, 2012-04-16 at 14:13 -0600, Grant Likely wrote:
> 
> > diff --git a/arch/powerpc/platforms/cell/axon_msi.c b/arch/powerpc/platforms/cell/axon_msi.c
> > index d09f3e8..fc9df1a 100644
> > --- a/arch/powerpc/platforms/cell/axon_msi.c
> > +++ b/arch/powerpc/platforms/cell/axon_msi.c
> > @@ -276,9 +276,6 @@ static int axon_msi_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
> >  	if (rc)
> >  		return rc;
> >  
> > -	/* We rely on being able to stash a virq in a u16 */
> 
> Would be nice to move the comment to the hunk below rather than just
> deleting it. Otherwise the 65536 looks a bit random.

Done.

g.

