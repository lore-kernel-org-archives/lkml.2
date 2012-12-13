Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172Ab2LMS12 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 13:27:28 -0500
Received: from host-176-100-244-43.masterbit.su ([176.100.244.43]:47267 "EHLO
	tservice.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755452Ab2LMS11 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 13:27:27 -0500
Date: Thu, 13 Dec 2012 22:27:22 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Julia Lawall <Julia.Lawall@lip6.fr>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] drivers/w1/masters/mxc_w1.c: use devm_ functions
Message-ID: <20121213182722.GA30828@ioremap.net>
References: <1354835724-26945-2-git-send-email-Julia.Lawall@lip6.fr>
 <20121211212555.GA15333@ioremap.net>
 <20121213093938.GX6568@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121213093938.GX6568@mwanda>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2012 at 12:39:38PM +0300, Dan Carpenter (dan.carpenter@oracle.com) wrote:
> On Wed, Dec 12, 2012 at 01:25:56AM +0400, Evgeniy Polyakov wrote:
> > I suppose mdev will be automatically freed, but who will release
> > mdev->clk and other private members of mdev structure?
> 
> +   mdev->clk = devm_clk_get(&pdev->dev, NULL);
> 
> ->clk is now a devm pointer as well.

Argh, I see it. Thanks for clarification.

-- 
	Evgeniy Polyakov
