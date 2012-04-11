Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554Ab2DKI0d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 04:26:33 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:38568 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523Ab2DKI0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 04:26:31 -0400
MIME-Version: 1.0
In-Reply-To: <4F844E52.3080902@wwwdotorg.org>
References: <1334044357-14486-1-git-send-email-linus.walleij@stericsson.com>
	<4F844E52.3080902@wwwdotorg.org>
Date: Wed, 11 Apr 2012 10:26:30 +0200
Message-ID: <CACRpkdYPD4iA2vdy-VOP2E+FfESJmbuMtLDVi0rGBn6FCCzuyA@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: fix build failure on PPC
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2012 at 5:14 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 04/10/2012 01:52 AM, Linus Walleij wrote:

>> So let's use some local Kconfig option that depends on both OF
>> and PINCTRL so that this file is only compiled if you have
>> both enabled.
>
> It seems simpler to just fix the Makefile to only compile the file when
> its needed directly, without introducing a new Kconfig option. See
> https://lkml.org/lkml/2012/4/3/445.

But I think it is basically a config problem, not a compilation problem,
that is why I did it this way.

But I won't be stubborn about it ... I'll see if I can just switch that one
patch out then.

Yours,
Linus Walleij
