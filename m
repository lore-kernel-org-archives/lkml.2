Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327Ab2LMLXz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 06:23:55 -0500
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:21493 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753789Ab2LMLXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 06:23:54 -0500
X-IronPort-AV: E=Sophos;i="4.84,273,1355094000"; 
   d="scan'208";a="185979272"
Date: Thu, 13 Dec 2012 12:23:39 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Dan Carpenter <dan.carpenter@oracle.com>
cc: Evgeniy Polyakov <zbr@ioremap.net>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] drivers/w1/masters/mxc_w1.c: use devm_ functions
In-Reply-To: <20121213112029.GY6568@mwanda>
Message-ID: <alpine.DEB.2.02.1212131222530.1966@hadrien>
References: <1354835724-26945-2-git-send-email-Julia.Lawall@lip6.fr> <20121211212555.GA15333@ioremap.net> <20121213093938.GX6568@mwanda> <alpine.DEB.2.02.1212131118220.1966@hadrien> <20121213112029.GY6568@mwanda>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Dec 2012, Dan Carpenter wrote:

> On Thu, Dec 13, 2012 at 11:18:53AM +0100, Julia Lawall wrote:
> > On Thu, 13 Dec 2012, Dan Carpenter wrote:
> >
> > > On Wed, Dec 12, 2012 at 01:25:56AM +0400, Evgeniy Polyakov wrote:
> > > > I suppose mdev will be automatically freed, but who will release
> > > > mdev->clk and other private members of mdev structure?
> > >
> > > +   mdev->clk = devm_clk_get(&pdev->dev, NULL);
> > >
> > > ->clk is now a devm pointer as well.
> >
> > Thanks for the suggestion.  I will submit a patch shortly.
> >
>
> Huh?  I think there is a miscommunication here.  I was trying to
> explain that your original patch handles releasing ->clk.
>
> I've reviewed the patch again and I still don't see a problem with
> it.  What will you change when you resubmit?

Oops, sorry.  I thought your +   mdev->clk = devm_clk_get(&pdev->dev,
NULL); was a suggestion of something I had overlooked.

Thanks,
julia
