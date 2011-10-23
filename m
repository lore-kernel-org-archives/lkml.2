Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358Ab1JWK7x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 06:59:53 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:10510 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024Ab1JWK7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 06:59:52 -0400
X-AuditID: cbfee61a-b7cf1ae00000208e-45-4ea3f3a6c681
From: Sangbeom Kim <sbkim73@samsung.com>
To: "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>
Cc: "'Liam Girdwood'" <lrg@ti.com>, linux-kernel@vger.kernel.org
References: <009501cc915b$809ce880$81d6b980$@com>
 <20111023093020.GC3135@opensource.wolfsonmicro.com>
In-reply-to: <20111023093020.GC3135@opensource.wolfsonmicro.com>
Subject: RE: [PATCH] regulator: Add S5M8767 regulator driver
Date: Sun, 23 Oct 2011 19:59:50 +0900
Message-id: <009901cc9172$e2a2ef90$a7e8ceb0$@com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AcyRZmTBZ04aCZo7SXa/GDwYr4dF9QAC2qjg
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 23, 2011 at 06:30 PM , Mark Brown wrote:
 
> I guess you need an implementation for enable_suspend() (otherwise you
> can't do disable->enable)
Ok, I will add it in the next version.

> 
> > +	{
> > +		.name	= "AP 32KHz",
> > +		.id	= S5M8767_32KHZAP_EN,
> > +		.ops	= &s5m8767_others_ops,
> > +		.type	= REGULATOR_VOLTAGE,
> > +		.owner	= THIS_MODULE,
> > +	}, {
> > +		.name	= "CP 32KHz",
> > +		.id	= S5M8767_32KHZAP_EN,
> > +		.ops	= &s5m8767_others_ops,
> > +		.type	= REGULATOR_VOLTAGE,
> > +		.owner	= THIS_MODULE,
> > +	},
> 
> Do these actually share anything with the other regulators?  If not then
> I guess it's better to do with the struct clk framework.

OK, I will consider clk framework

 
> > +				dev_warn(&pdev->dev, "Duplicated gpio
> > request"
> > +						" for SET3\n");
> 
> Please keep the strings on one line (it makes grepping for errors
> easier).

Thanks,
Sangbeom.

