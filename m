Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214Ab0LMHOb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 02:14:31 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:54297 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753Ab0LMHOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 02:14:30 -0500
MIME-Version: 1.0
In-Reply-To: <1291933475.3271.211.camel@odin>
References: <AANLkTi=L0fXFnF2-u+zdObs56h-FYgedhe0adxOAuCq=@mail.gmail.com>
	<1291933475.3271.211.camel@odin>
Date: Mon, 13 Dec 2010 15:14:29 +0800
Message-ID: <AANLkTi=Ry7=wofZgHFO6_4TxLs1TPTPbEbH=4JP1cvD_@mail.gmail.com>
Subject: Re: [PATCH 1/2] Change the register name definitions for mc13783
From: Yong Shen <yong.shen@linaro.org>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: List Linux Arm Kernel <linux-arm-kernel@lists.infradead.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Liam,

On Fri, Dec 10, 2010 at 6:24 AM, Liam Girdwood <lrg@slimlogic.co.uk> wrote:
> On Thu, 2010-12-02 at 18:43 +0800, Yong Shen wrote:
>> Hi there,
>>
>> Please give comments inline and use attached patch for testing.
>>
>> Thanks
>> Yong
>>
>> >From e112153c6f03b49c229a8e3913a0c0459245df20 Mon Sep 17 00:00:00 2001
>> From: Yong Shen <yong.shen@linaro.org>
>> Date: Thu, 2 Dec 2010 14:17:02 +0800
>> Subject: [PATCH 1/2] Change the register name definitions for mc13783
>>
>> To make mc13783 and mc13892 share code, the register names should be
>> changed to fit the new macro definitions in the comming patch.
>
> I've just tried to apply this patch and looks like your mailer has
> mangled parts of it. I repaired it and sadly it still does not apply
> against the regulator tree.
>
> git://git.kernel.org/pub/scm/linux/kernel/git/lrg/voltage-2.6.git #for-next
>
> Can you redo, add the acks received and resubmit.
Sure, I can redo it.

Yong

>
> Thanks
>
> Liam
>
>
