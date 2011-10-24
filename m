Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932257Ab1JXM23 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 08:28:29 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61555 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932216Ab1JXM22 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 08:28:28 -0400
MIME-Version: 1.0
In-Reply-To: <CAMjpGUcWUp05SkBi1JWL+NFBCcZV5=EaidtYkEbONPheVwhjgw@mail.gmail.com>
References: <1317211419-18472-1-git-send-email-linus.walleij@stericsson.com>
	<20110930020754.GK12606@ponder.secretlab.ca>
	<CACRpkdYyyqB6=5M8reqgwpMxXJz5ttXWyOav6K58dQ0CrxwCNA@mail.gmail.com>
	<CACxGe6v19pZ0i-+ksYZbG2ZvGT30UkXEHTzpZMBTB4RNUV5bnA@mail.gmail.com>
	<CAKnu2MpQ8Wvd4TF8Ge=o8ACyEoaEY8TcvOSdT1w6zfYiSKFUiw@mail.gmail.com>
	<20111004203520.GK2870@ponder.secretlab.ca>
	<CAMjpGUe9abPsdWbum2MRzOV2b5_2FDqXZC-K0KThRA6MNTr4FA@mail.gmail.com>
	<CACRpkdatiBathcoo2VjKs9jHJiKC5trDCJ0bePX1q6KbrYRN-g@mail.gmail.com>
	<20111024073604.GA8708@ponder.secretlab.ca>
	<CACRpkdZ6DCeELLhiXF=oOMKB-DxeMuvbd_c6n4H1UDMhpHKZbA@mail.gmail.com>
	<CAMjpGUcWUp05SkBi1JWL+NFBCcZV5=EaidtYkEbONPheVwhjgw@mail.gmail.com>
Date: Mon, 24 Oct 2011 14:28:26 +0200
Message-ID: <CACRpkdbbNTGd3opbeAiY2uMpPzD+G_vj=jq_fiArhjosPXyMRQ@mail.gmail.com>
Subject: Re: [PATCH] drivers: create a pin control subsystem v8
From: Linus Walleij <linus.walleij@linaro.org>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.ml.walleij@gmail.com>,
        Stephen Warren <swarren@nvidia.com>,
        Sascha Hauer <s.hauer@pengutronix.de>, Barry Song <21cnbao@gmail.com>,
        linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Lee Jones <lee.jones@linaro.org>, David Brown <davidb@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org,
        Stijn Devriendt <highguy@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 24, 2011 at 11:20 AM, Mike Frysinger <vapier.adi@gmail.com> wrote:

> but the question here is about pinctrl.  does userspace really need to
> manipulate the pinmapping ?  if we agree on that, then the question is
> on the userspace interface.
>
> assuming we want this, i can't see the performance argument being made
> here for pinctrl.  which means doing a sysfs interface here like we
> already have with GPIO makes the most sense.  GPIO deals in "binary"
> data for the most part (reading/writing 0/1 ints) so the string-based
> sysfs parsing is a bit weird, but pinctrl deals with strings
> everywhere for selecting mapping groups, so sysfs is the natural
> answer.

Hm now I feel I start to agree with you and come back to my
original proposition to do pinctrl in sysfs after all.

I wonder how soon we have a practical use case for this.
We do have this hacked-up driver in ux500:
http://git.linaro.org/gitweb?p=bsp/st-ericsson/linux-3.0-ux500.git;a=tree;f=drivers/staging/ab5500_sim;hb=HEAD

This controls a lot of SIM card pins from userspace...

Yours,
Linus Walleij
