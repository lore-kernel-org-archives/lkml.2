Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199Ab1D3G2M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 02:28:12 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:57128 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496Ab1D3G2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 02:28:10 -0400
Date: Sat, 30 Apr 2011 00:28:06 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: devicetree-discuss@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 5/8] arm/dt: Drop irq_create_of_mapping() from arm
 code.
Message-ID: <20110430062806.GA3103@ponder.secretlab.ca>
References: <20110429070135.12522.35745.stgit@ponder>
 <20110429071553.12522.65073.stgit@ponder>
 <alpine.LFD.2.00.1104292027560.24613@xanadu.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1104292027560.24613@xanadu.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 29, 2011 at 08:28:47PM -0400, Nicolas Pitre wrote:
> On Fri, 29 Apr 2011, Grant Likely wrote:
> 
> > It is now implemented by core code.
> > 
> > Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> > ---
> >  arch/arm/kernel/devtree.c |   14 --------------
> >  1 files changed, 0 insertions(+), 14 deletions(-)
> 
> Maybe this should be folded in the patch that introduced this instead?

Yes, it should; but I've kept it separate for now because I don't have
an ack from benh to merge the core changes that do this yet.  When
that happens I'll squish the two patches together.

g.

