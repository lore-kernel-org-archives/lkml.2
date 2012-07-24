Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199Ab2GXDWV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 23:22:21 -0400
Received: from gate.crashing.org ([63.228.1.57]:53535 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753125Ab2GXDWU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 23:22:20 -0400
Message-ID: <1343100106.3715.2.camel@pasglop>
Subject: Re: next/mmotm unbootable on G5: irqdomain
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Hugh Dickins <hughd@google.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Milton Miller <miltonm@bga.com>,
        Paul Mundt <lethal@linux-sh.org>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Date: Tue, 24 Jul 2012 13:21:46 +1000
In-Reply-To: <CACxGe6udruWL7oo6Qp6jkwQYceduTO1h1gKFz9TFX1TPZoNFNQ@mail.gmail.com>
References: <alpine.LSU.2.00.1207211911160.1585@eggly.anvils>
	 <1343011543.2957.2.camel@pasglop>
	 <CACxGe6uFvtro7iR8FewgChLr_6PnZA-EaRMKQjrFEaEHg7SKRQ@mail.gmail.com>
	 <1343082371.2957.39.camel@pasglop>
	 <CACxGe6uo8jx3GQFQpQ5RTHF5JyN2hEgvcvdmSYfGyTQnzK9fOA@mail.gmail.com>
	 <CACxGe6udruWL7oo6Qp6jkwQYceduTO1h1gKFz9TFX1TPZoNFNQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-23 at 16:32 -0600, Grant Likely wrote:
> > As-is I'm backing off from the linear/legacy/tree merge patch as just
> > too risky. I've already pulled that stuff out of linux-next.
> 
> Can I pull you pseries fix into my tree (my preference), or do I need
> to rebase on top of yours? 

The mpic fix for the g5 is in Linus tree already, I added it on top of
powerpc -next before I asked Linus to pull.

For pseries (ie the fix for irq_find_mapping vs. radix), I don't have a
formal patch, just the one I hand typed in my previous email, so do
whatever you want with it.

Cheers,
Ben.


