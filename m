Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453Ab2LMJkM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 04:40:12 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:42647 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab2LMJkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 04:40:09 -0500
Date: Thu, 13 Dec 2012 12:39:38 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Julia Lawall <Julia.Lawall@lip6.fr>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] drivers/w1/masters/mxc_w1.c: use devm_ functions
Message-ID: <20121213093938.GX6568@mwanda>
References: <1354835724-26945-2-git-send-email-Julia.Lawall@lip6.fr>
 <20121211212555.GA15333@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121211212555.GA15333@ioremap.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2012 at 01:25:56AM +0400, Evgeniy Polyakov wrote:
> I suppose mdev will be automatically freed, but who will release
> mdev->clk and other private members of mdev structure?

+   mdev->clk = devm_clk_get(&pdev->dev, NULL);

->clk is now a devm pointer as well.

regards,
dan carpenter

