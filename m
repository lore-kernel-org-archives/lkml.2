Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752361Ab2AANcv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jan 2012 08:32:51 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58798 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096Ab2AANct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jan 2012 08:32:49 -0500
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF176BE92A7E@HQMAIL01.nvidia.com>
References: <1323993437-15149-1-git-send-email-swarren@nvidia.com>
	<1323993437-15149-2-git-send-email-swarren@nvidia.com>
	<CACRpkdaKWcCReO27O6VjQNBCnSDu_tMLPLCkqR0aroUf7gLEVw@mail.gmail.com>
	<74CDBE0F657A3D45AFBB94109FB122FF176BE92A7E@HQMAIL01.nvidia.com>
Date: Sun, 1 Jan 2012 14:32:48 +0100
Message-ID: <CACRpkda4F3K3A2GfPDAVds9NhJZqehtgUT+8Xt_RMctWcna7vQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] pinctrl: Pass name instead of device to pin_config_*
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 19, 2011 at 7:20 PM, Stephen Warren <swarren@nvidia.com> wrote:
> Linus Walleij wrote at Sunday, December 18, 2011 3:27 PM:
>>
>> I had to fix it up a bit to match the other
>> refactoring patch I made so check the result in my tree or -next.
>
> Yes, I think that looks fine, thanks.
>
> Thanks for fixing up the documentation for me too.
>
> BTW, do you know which commits you're planning on you're planning on
> sending to mainline during the next merge window? If it includes these
> two patches,

Yes, everything that has landed in -next will be sent upstream,
including this.

> I may be able to convert Tegra over to using the new pinctrl
> driver in 3.3. And is your for-next branch stable (i.e. never rebased)
> so that the arm-soc tree can use it as a dependency for my patches?

It is rebased infrequently, and never this late in the -rc series.
I may add fixes on top though.

The for-next branch is basically a subset of devel excluding
any controversial stuff, so up to a certain point, then I keep
the under discussion stuff on top of for-next.

Thanks,
Linus Walleij
