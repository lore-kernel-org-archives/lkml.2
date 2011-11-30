Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756945Ab1K3PXB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 10:23:01 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:35516 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333Ab1K3PW7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 10:22:59 -0500
MIME-Version: 1.0
In-Reply-To: <201111301330.09043.arnd.bergmann@linaro.org>
References: <1322656361-6463-1-git-send-email-linus.walleij@stericsson.com>
	<201111301330.09043.arnd.bergmann@linaro.org>
Date: Wed, 30 Nov 2011 16:22:58 +0100
Message-ID: <CACRpkda5H+cwr7Gz3LwV=Q-PV9Och3Eb1cf3nNcr1_pYbZ_sRQ@mail.gmail.com>
Subject: Re: [PATCH 1/2 v3] pinctrl: make a copy of pinmux map
From: Linus Walleij <linus.walleij@linaro.org>
To: Arnd Bergmann <arnd.bergmann@linaro.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 30, 2011 at 2:30 PM, Arnd Bergmann <arnd.bergmann@linaro.org> wrote:

> Reviewed-by: Arnd Bergmann <arnd@linaro.org>

Thanks!

>> +     int ret = 0;
(...)
>
> A trick pointed out by Rusty Russell in a recent blog post [1] is to
> not initialize the return value initially, but always set it only
> in the error path so that the compiler can warn you when you ever
> forget setting it in one path.

Clever! I do away with ret altogether in the next patch though,
so I'll remember this another time. Maybe even something for
checkpatch to react on...

Yours,
Linus Walleij
