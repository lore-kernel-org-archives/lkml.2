Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688Ab2BPTjl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 14:39:41 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49025 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791Ab2BPTjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 14:39:39 -0500
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF1790EC8791@HQMAIL01.nvidia.com>
References: <1329417828-6005-1-git-send-email-linus.walleij@linaro.org>
	<74CDBE0F657A3D45AFBB94109FB122FF1790EC8791@HQMAIL01.nvidia.com>
Date: Thu, 16 Feb 2012 20:39:39 +0100
Message-ID: <CACRpkdavPdK13cJ-mdDXwbz3jNCSCzaa8LTdMDXOy4mi+pmdmw@mail.gmail.com>
Subject: Re: [PATCH] serial/sirf: fixup for changes to pin control
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Barry Song <21cnbao@gmail.com>, Tony Lindgren <tony@atomide.com>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 16, 2012 at 8:01 PM, Stephen Warren <swarren@nvidia.com> wrote:

> Should this patch be put into the pinctrl tree since that's where the
> API changed, perhaps even squashed into the original commit to avoid
> git bisect breakage, unless your branch needs to be stable?

Hm yeah I will for sure put it into the pinctrl tree.
The Sirf doesn't even have a defconfig so it was just my memory of
the Sirf that got me to remember it. I might squash if I don't get any
comments on this patch.

> Otherwise,
> this change will conflict with my future similar change if pulled for
> the same kernel version.

It'll be in linux-next tomorrow or so.

Yours,
Linus Walleij
