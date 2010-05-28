Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755715Ab0E1Hbm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 03:31:42 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:59161 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752945Ab0E1Hbk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 03:31:40 -0400
Date: Fri, 28 May 2010 09:31:34 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Joerg Roedel <joro@8bytes.org>, Nicolas Palix <npalix@diku.dk>,
       Randy Dunlap <rdunlap@xenotime.net>, Roland Dreier <rdreier@cisco.com>,
       Joe Perches <joe@perches.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>, Michal Marek <mmarek@suse.cz>,
       Sam Ravnborg <sam@ravnborg.org>, Gilles Muller <Gilles.Muller@lip6.fr>,
       linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
       cocci@diku.dk, Kernel Janitors <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH 0/4] Add a Coccinelle front-end script
In-Reply-To: <20100528072504.GB3344@pengutronix.de>
Message-ID: <Pine.LNX.4.64.1005280931230.9138@ask.diku.dk>
References: <1273508667-5152-1-git-send-email-npalix@diku.dk>
 <20100528070921.GK1237@8bytes.org> <20100528072504.GB3344@pengutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 May 2010, Wolfram Sang wrote:

> > Don't know how complex the coccinelle software itself is, but I think it
> > would make sense to ship it with the kernel-sources too. That together
> 
> You can easily find out by browsing the homepage of coccinelle.

Over 100 000 lines of code.

julia
