Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752395Ab2AANgb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jan 2012 08:36:31 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53237 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045Ab2AANg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jan 2012 08:36:29 -0500
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF176BE92A8E@HQMAIL01.nvidia.com>
References: <1324248425-26552-1-git-send-email-linus.walleij@stericsson.com>
	<74CDBE0F657A3D45AFBB94109FB122FF176BE92A8E@HQMAIL01.nvidia.com>
Date: Sun, 1 Jan 2012 14:36:29 +0100
Message-ID: <CACRpkdaNm0ksAvRLJcBeTx33-EiLTnJZLJMEG45+vzwum2JN2A@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: rename U300 ans SIRF pin controllers
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Rongjun Ying <Rongjun.Ying@csr.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 19, 2011 at 7:29 PM, Stephen Warren <swarren@nvidia.com> wrote:

> Do you want to change the DRIVER_NAME define in those two drivers and
> s/pinmux/pinctrl/ there? Perhaps that's not a good idea, but I thought
> I'd ask in case you meant to.

I'll keep that as a separate cleanup per-driver, but it's a good idea for the
next development cycle.

Thanks,
Linus Walleij
