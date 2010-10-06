Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932594Ab0JFJb6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 05:31:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45983 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757258Ab0JFJb4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 05:31:56 -0400
Date: Wed, 6 Oct 2010 11:31:55 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Antonio Ospite <ospite@studenti.unina.it>
Cc: Greg KH <greg@kroah.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Neukum <oliver@neukum.name>,
        stable@kernel.org, Alan Ott <alan@signal11.us>
Subject: Re: [stable] [PATCH 0/2] HID: hidraw, fix two NULL pointer
 dereferences
In-Reply-To: <20101005221619.88904313.ospite@studenti.unina.it>
Message-ID: <alpine.LNX.2.00.1010061130430.29535@pobox.suse.cz>
References: <alpine.LNX.2.00.1010041548580.29535@pobox.suse.cz> <1286292017-6746-1-git-send-email-ospite@studenti.unina.it> <20101005174200.GB29937@kroah.com> <20101005221619.88904313.ospite@studenti.unina.it>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Oct 2010, Antonio Ospite wrote:

> > > here are some fixes to hidraw.
> > > 
> > > Patches are against 2.6.36-rc6, but they should be ported to other
> > > maintained stable kernels as well.
> > > 
> [...]
> > > 
> > > The first one has been sent already but I am resending it with
> > > stable@stable@kernel.org in the recipients list.
> > 
> > Please read Documentation/stable_kernel_rules.txt which shows you how to
> > properly notify the stable developer to pick up the patch (hint, cc:ing
> > them on the patch is not the correct way, you need to add the mark to
> > the signed-off-by: area.)
> > 
> 
> I see now, thanks Greg.
> 
> Jiri, are you adding the Cc: mark to these when you apply them? I
> misunderstood your previous statement about that and thought CCing like
> in recipients was enough.
> 
> There is one thing which is not 100% clear to me from the doc (my
> fault): are patches targeted to -stable to be sent _twice_? Once for
> linus master branch (this is what "upstream" means in that context,
> isn't it?) and once for -stable with the commit ID of the former? Is
> the Cc mark meant just to automate this very process? It seemed to me
> that items 1 and 2 of the "Procedure" in
> Documentation/stable_kernel_rules.txt are alternative each other.

Either you have to send it twice, or you can ad 'Cc: stable@kernel.org' to 
the patch meta-information, and it will be picked up for stable 
automatically once it lands in Linus' tree.

I have added the 'Cc:' markings now and applied both patches, thanks.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
