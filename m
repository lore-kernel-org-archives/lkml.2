Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752401Ab2CHFxL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 00:53:11 -0500
Received: from gate.crashing.org ([63.228.1.57]:60968 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090Ab2CHFxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 00:53:09 -0500
Message-ID: <1331185951.3105.29.camel@pasglop>
Subject: Re: linux-next: manual merge of the powerpc tree with the arm tree
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Michael Neuling <mikey@neuling.org>, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org, Russell King <rmk@arm.linux.org.uk>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>
Date: Thu, 08 Mar 2012 16:52:31 +1100
In-Reply-To: <20120308145131.fad50bbc79c36f0b0b12d101@canb.auug.org.au>
References: <20120308120422.e071cba36425eacbee1f8d98@canb.auug.org.au>
	 <25744.1331174036@neuling.org>
	 <20120308145131.fad50bbc79c36f0b0b12d101@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-08 at 14:51 +1100, Stephen Rothwell wrote:
> Hi Mikey,
> 
> On Thu, 08 Mar 2012 13:33:56 +1100 Michael Neuling <mikey@neuling.org> wrote:
> >
> > Surely we only need SPARSE_IRQ now and not MAY_HAVE_SPARSE_IRQ.  
> > 
> > In fact, keeping MAY_HAVE_SPARSE_IRQ seems to make SPARSE_IRQ user
> > selectable, which we don't want anymore since ad5b7f1350c2.
> 
> Yes, indeed. I will fix up the merge resolution for tomorrow.

This is my fault. Grant's patch had a collision and I manually fixed it
up. While doing that, I put back MAY_HAVE_SPARSE_IRQ which the patch
originally took out.

Cheers,
Ben.


