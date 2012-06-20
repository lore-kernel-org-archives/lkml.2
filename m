Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796Ab2FTPd3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 11:33:29 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:46539 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755680Ab2FTPd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 11:33:28 -0400
Message-ID: <4FE1ED43.3000509@wwwdotorg.org>
Date: Wed, 20 Jun 2012 09:33:23 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: axel.lin@gmail.com, Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Kim, Milo" <Milo.Kim@ti.com>
Subject: Re: linux-next: build failure after merge of the regulator tree
References: <20120620145044.599244256884c96a9131a06f@canb.auug.org.au> <CAF+7xWkMSuS3hcWMjKX8OdaLW038eQ-Es+WZeVja3iUiTXMWeQ@mail.gmail.com>
In-Reply-To: <CAF+7xWkMSuS3hcWMjKX8OdaLW038eQ-Es+WZeVja3iUiTXMWeQ@mail.gmail.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2012 10:55 PM, Axel Lin wrote:
> 2012/6/20 Stephen Rothwell <sfr@canb.auug.org.au>:
>> Hi all,
>>
>> After merging the regulator tree, today's linux-next build (x86_64
>> allmodconfig) failed like this:
>>
>> ERROR: "devm_gpio_request_one" [drivers/regulator/lp872x.ko] undefined!
>>
>> Caused by commit af8b5fc31099 ("regulator: add new regulator driver for
>> lp872x").
> 
> Milo already sent a patch for this:
> 
> [PATCH] gpio: add EXPORT_SYMBOL() for devm_gpio_request_one
> https://lkml.org/lkml/2012/6/19/58

As did I earlier:
https://lkml.org/lkml/2012/6/7/601

I hope that can go into 3.5, since the issue shows up there when
building Tegra audio as modules.
