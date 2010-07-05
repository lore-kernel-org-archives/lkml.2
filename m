Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757307Ab0GENo3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 09:44:29 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:49278 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753829Ab0GENoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 09:44:15 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18UEnzQXsriRZlYDH5bT9gV
Date: Mon, 5 Jul 2010 16:44:02 +0300
From: Tony Lindgren <tony@atomide.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Nicolas Pitre <nico@fluxnic.net>, linux-omap@vger.kernel.org,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Russell King <rmk@arm.linux.org.uk>
Subject: Re: linux-next: manual merge of the omap tree with the arm tree
Message-ID: <20100705134401.GC15951@atomide.com>
References: <20100705092055.859d31d8.sfr@canb.auug.org.au>
 <alpine.LFD.2.00.1007042144410.6020@xanadu.home>
 <20100705171428.cb58b867.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100705171428.cb58b867.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Stephen Rothwell <sfr@canb.auug.org.au> [100705 10:08]:
> Hi Nicolas,
> 
> On Sun, 04 Jul 2010 21:46:27 -0400 (EDT) Nicolas Pitre <nico@fluxnic.net> wrote:
> >
> > Yes, the fix is fine.  If you can carry it until either of those is 
> > merged upstream that would be great.
> 
> Thanks for the confirmation.  I can carry the merge fix as long as
> necessary.

Thanks, I've dropped this patch from omap for-next branch, I'll send
it into Russell's patch system.

Regards,

Tony
