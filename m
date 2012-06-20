Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996Ab2FTE4E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 00:56:04 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:41817 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566Ab2FTE4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 00:56:02 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <20120620145044.599244256884c96a9131a06f@canb.auug.org.au>
References: <20120620145044.599244256884c96a9131a06f@canb.auug.org.au>
From: Axel Lin <axel.lin@gmail.com>
Date: Wed, 20 Jun 2012 12:55:41 +0800
Message-ID: <CAF+7xWkMSuS3hcWMjKX8OdaLW038eQ-Es+WZeVja3iUiTXMWeQ@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the regulator tree
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Kim, Milo" <Milo.Kim@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/6/20 Stephen Rothwell <sfr@canb.auug.org.au>:
> Hi all,
>
> After merging the regulator tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>
> ERROR: "devm_gpio_request_one" [drivers/regulator/lp872x.ko] undefined!
>
> Caused by commit af8b5fc31099 ("regulator: add new regulator driver for
> lp872x").

Milo already sent a patch for this:

[PATCH] gpio: add EXPORT_SYMBOL() for devm_gpio_request_one
https://lkml.org/lkml/2012/6/19/58

Also CCed Grant
