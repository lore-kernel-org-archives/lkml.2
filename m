Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758894Ab2FUImz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 04:42:55 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:41795 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758868Ab2FUImp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 04:42:45 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "axel.lin@gmail.com" <axel.lin@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>, "Girdwood, Liam" <lrg@ti.com>
Subject: RE: linux-next: build failure after merge of the regulator tree
Thread-Topic: linux-next: build failure after merge of the regulator tree
Thread-Index: AQHNT13W1qE+8LrsRUWr/x172e/ldZcEaidw//9+hACAAImoQA==
Date: Thu, 21 Jun 2012 08:42:33 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998FC08A@DQHE02.ent.ti.com>
References: <20120621132738.6e797593acc58b3e30902f69@canb.auug.org.au>
 <A874F61F95741C4A9BA573A70FE3998FC074@DQHE02.ent.ti.com>
 <CAF+7xWkzKkwfBFQS1vr-Tk2Auu+5HQmX7bZCGJhsmXRi0V5OZw@mail.gmail.com>
In-Reply-To: <CAF+7xWkzKkwfBFQS1vr-Tk2Auu+5HQmX7bZCGJhsmXRi0V5OZw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> BTW, In yesterday's linux-next tree, Andrew has below commit.
> 
> commit a291ede7be8359a8986740b11b93f9c80e40210b
> Author: Andrew Morton <akpm@linux-foundation.org>
> Date:   Wed Jun 20 09:55:47 2012 +1000
> 
>     backlight-l4f00242t03-use-devm_gpio_request_one-fix
> 
>     export devm_gpio_request_one() to modules
> 
>     Cc: Alberto Panizzo <alberto@amarulasolutions.com>
>     Cc: Jingoo Han <jg1.han@samsung.com>
>     Cc: Richard Purdie <rpurdie@rpsys.net>
>     Cc: Grant Likely <grant.likely@secretlab.ca>
>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Axel,
Good, thanks a lot !

Mark,
Then please ignore the patch below.
'[PATCH 2/3] regulator: replace devm_gpio_request_one() for loaded module'
https://lkml.org/lkml/2012/6/21/62

But two patches are still valid.
'[PATCH 1/3] regulator: enable module build config for lp872x'
'[PATCH 3/3] regulator: change message level on probing lp872x driver'
https://lkml.org/lkml/2012/6/21/61
https://lkml.org/lkml/2012/6/21/57

Thanks & BR
Milo -
