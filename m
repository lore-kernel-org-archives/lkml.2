Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973Ab2LMLU5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 06:20:57 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:51627 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753337Ab2LMLUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 06:20:55 -0500
Date: Thu, 13 Dec 2012 14:20:29 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Evgeniy Polyakov <zbr@ioremap.net>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] drivers/w1/masters/mxc_w1.c: use devm_ functions
Message-ID: <20121213112029.GY6568@mwanda>
References: <1354835724-26945-2-git-send-email-Julia.Lawall@lip6.fr>
 <20121211212555.GA15333@ioremap.net>
 <20121213093938.GX6568@mwanda>
 <alpine.DEB.2.02.1212131118220.1966@hadrien>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1212131118220.1966@hadrien>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2012 at 11:18:53AM +0100, Julia Lawall wrote:
> On Thu, 13 Dec 2012, Dan Carpenter wrote:
> 
> > On Wed, Dec 12, 2012 at 01:25:56AM +0400, Evgeniy Polyakov wrote:
> > > I suppose mdev will be automatically freed, but who will release
> > > mdev->clk and other private members of mdev structure?
> >
> > +   mdev->clk = devm_clk_get(&pdev->dev, NULL);
> >
> > ->clk is now a devm pointer as well.
> 
> Thanks for the suggestion.  I will submit a patch shortly.
> 

Huh?  I think there is a miscommunication here.  I was trying to
explain that your original patch handles releasing ->clk.

I've reviewed the patch again and I still don't see a problem with
it.  What will you change when you resubmit?

regards,
dan carpenter

