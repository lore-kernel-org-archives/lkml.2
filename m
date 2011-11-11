Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757212Ab1KKPVV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 10:21:21 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61341 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752947Ab1KKPVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 10:21:20 -0500
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF1740805401@HQMAIL01.nvidia.com>
References: <1320913807-19928-1-git-send-email-linus.walleij@stericsson.com>
	<74CDBE0F657A3D45AFBB94109FB122FF1740805401@HQMAIL01.nvidia.com>
Date: Fri, 11 Nov 2011 16:21:19 +0100
Message-ID: <CACRpkdZP=nOf-uByZDPd+C5ehrQDU2-SWxVFDMD3a0rv0z99iw@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: documentation update
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 10, 2011 at 4:58 PM, Stephen Warren <swarren@nvidia.com> wrote:
> Linus Walleij wrote at Thursday, November 10, 2011 1:30 AM:
>> Update the docs removing an obsolete __refdata tag and document
>> the mysterious return value of pin_free().
>>
>> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
>
> Once the typo I mention below is fixed,
> Acked-by: Stephen Warren <swarren@nvidia.com>
>
> ...
>> + * for callers that dynamically allocate a function name so it can be free:ed
>
> s/free:ed/freed/ I think?

OK fixed, thanks!

Linus Walleij
