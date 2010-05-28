Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757500Ab0E1JPX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 05:15:23 -0400
Received: from 8bytes.org ([88.198.83.132]:43042 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753028Ab0E1JPV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 05:15:21 -0400
Date: Fri, 28 May 2010 11:15:20 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Julia Lawall <julia@diku.dk>
Cc: Wolfram Sang <w.sang@pengutronix.de>, Nicolas Palix <npalix@diku.dk>,
       Randy Dunlap <rdunlap@xenotime.net>, Roland Dreier <rdreier@cisco.com>,
       Joe Perches <joe@perches.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>, Michal Marek <mmarek@suse.cz>,
       Sam Ravnborg <sam@ravnborg.org>, Gilles Muller <Gilles.Muller@lip6.fr>,
       linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
       cocci@diku.dk, Kernel Janitors <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH 0/4] Add a Coccinelle front-end script
Message-ID: <20100528091520.GL1237@8bytes.org>
References: <1273508667-5152-1-git-send-email-npalix@diku.dk> <20100528070921.GK1237@8bytes.org> <20100528072504.GB3344@pengutronix.de> <Pine.LNX.4.64.1005280931230.9138@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1005280931230.9138@ask.diku.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 28, 2010 at 09:31:34AM +0200, Julia Lawall wrote:
> On Fri, 28 May 2010, Wolfram Sang wrote:
> 
> > > Don't know how complex the coccinelle software itself is, but I think it
> > > would make sense to ship it with the kernel-sources too. That together
> > 
> > You can easily find out by browsing the homepage of coccinelle.
> 
> Over 100 000 lines of code.

I just noticed that distributions already ship it in their repositories.
So this its okay to keep it outside the kernel sources.

	Joerg

