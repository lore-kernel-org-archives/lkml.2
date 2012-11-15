Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768740Ab2KOTFo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 14:05:44 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:42317 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423636Ab2KOTFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 14:05:42 -0500
MIME-Version: 1.0
In-Reply-To: <20121115185522.GA4077@core.coreip.homeip.net>
References: <20121103013623.0f3a1b28168a9a42881b0b00@tw.synaptics.com>
	<20121113201212.8550fb074e1f7cce78f29d97@tw.synaptics.com>
	<20121113175309.GA3601@polaris.bitmath.org>
	<CC51EC7B5B7F984AA566DC102237848896F62894@hkdcw-mail1.synaptics-inc.local>
	<20121114180401.GC29131@core.coreip.homeip.net>
	<CC51EC7B5B7F984AA566DC102237848896F6299E@hkdcw-mail1.synaptics-inc.local>
	<20121115064359.GA17551@core.coreip.homeip.net>
	<CACRpkdZtsTpNiRBzs3rUz48AvoZ4UpcrO-4__xmsb0XezUVFtg@mail.gmail.com>
	<20121115185522.GA4077@core.coreip.homeip.net>
Date: Thu, 15 Nov 2012 20:05:41 +0100
Message-ID: <CACRpkdbB5ijaRLmiB2DbFGunJQUUAM2+nhwBOOqSkMWQZVNHTQ@mail.gmail.com>
Subject: Re: [RFC] staging: ste_rmi4: merge into the main kernel tree
From: Linus Walleij <linus.walleij@linaro.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Alexandra Chin <alexandra.chin@tw.synaptics.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>,
        Mahesh Srinivasan <msrinivasan@synaptics.com>,
        Alex Chang <alex.chang@tw.synaptics.com>,
        Scott Lin <scott.lin@tw.synaptics.com>,
        Christopher Heiny <Cheiny@synaptics.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 15, 2012 at 7:55 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Thu, Nov 15, 2012 at 06:41:26PM +0100, Linus Walleij wrote:
>>
>> The benefit is that the ugliness in
>> drivers/staging/ste_rmi4/board-mop500-u8500uib-rmi4.c
>> can be avoided, as today we're unable to pass the compulsory
>> platform data in any sane way. I'm being told that this weak symbol
>> override actually does not really work... especially if there are more
>> than 1 I2C device on the bus :-P
>
> I am confused as to why this would be a benefit of ste_rmi4 over full
> RMI4 implementation from Christopher's group?

So we don't need to keep our real platform data and board files
out-of-tree like we've done for the last 2 years or so.

But I only said it's a benefit, not that I think it's a good idea.

> I think what we really need is to accelerate work on the full driver so
> it is in mainline in 3.9ish.

Yep, agreed.

Yours,
Linus Walleij
