Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965868Ab2B2SJm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 13:09:42 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53948 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965299Ab2B2SJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 13:09:41 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus.walleij@linaro.org designates 10.50.203.98 as permitted sender) smtp.mail=linus.walleij@linaro.org
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF17BDDF209F@HQMAIL01.nvidia.com>
References: <1330460852-23486-1-git-send-email-swarren@nvidia.com>
	<CACRpkdbtH7edRVc=BmCncabMzQ=OB8eQAYju3Aoh-zSnFGQ6sA@mail.gmail.com>
	<74CDBE0F657A3D45AFBB94109FB122FF17BDDF209F@HQMAIL01.nvidia.com>
Date: Wed, 29 Feb 2012 19:09:40 +0100
Message-ID: <CACRpkdYH7fim_-O3Ny0qewb=f3sdCof=Heq-Z+X019Lj__MEKQ@mail.gmail.com>
Subject: Re: [PATCH V2 0/6] pinctrl: API rework, pinconfig in mapping table, ...
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        "B29396@freescale.com" <B29396@freescale.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "dongas86@gmail.com" <dongas86@gmail.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "thomas.abraham@linaro.org" <thomas.abraham@linaro.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 29, 2012 at 6:42 PM, Stephen Warren <swarren@nvidia.com> wrote:
> Linus Walleij wrote at Wednesday, February 29, 2012 9:46 AM:
>> On Tue, Feb 28, 2012 at 9:27 PM, Stephen Warren <swarren@nvidia.com> wrote:
>>
>> > This is the current set of patches I have outstanding for pinctrl.
>>
>> Thanks, now the problem is that I think this is based on top of
>> the other two patches, which happen to break U300 so I cannot
>> test it :-(
>
> I think this series will unbreak U300, i.e. if you apply everything
> it'll all work fine?

Hm I wanted to try this but it seems patch 4/6 isn't on the list?

Strange ... oh well I guess I'll test the next respin instead.

Thanks,
Linus Walleij
