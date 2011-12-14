Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757700Ab1LNRNa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 12:13:30 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33409 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755129Ab1LNRN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 12:13:28 -0500
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF176B446FFD@HQMAIL01.nvidia.com>
References: <1323851530-4171-1-git-send-email-linus.walleij@stericsson.com>
	<74CDBE0F657A3D45AFBB94109FB122FF176B446FFD@HQMAIL01.nvidia.com>
Date: Wed, 14 Dec 2011 18:13:27 +0100
Message-ID: <CACRpkdbjQYCcv9LBVoDb1MkSuqLYfrgb9Hr5w7TKYVoJCLwWGA@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: add a group-specific hog macro
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 4:46 PM, Stephen Warren <swarren@nvidia.com> wrote:
> Linus Walleij wrote at Wednesday, December 14, 2011 1:32 AM:
>> To create elegant tables for pinmux hogs on the PXA MMP platform,
>> we need this hog macro that can specify both function and group in
>> one go.
>>
>> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
>
> Acked-by: Stephen Warren <swarren@nvidia.com>
>
> That said, when using this, I'd wrap it in a macro that set .name and
> .group to the same thing; for system hogs, I'm not sure what other name
> would be useful. Should the macro do that?

Nah I want to keep these namespaces separate. I can see why you'd
want to do that but it could be confusing too, some may want to
say, prefix the map entry name with the board name (or a board
wildcard like "mop500*" or nifty things like that so they see "OK these
entries are for all boards, these are for this specific variant..." etc.

Linus Walleij
