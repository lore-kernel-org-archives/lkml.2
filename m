Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894Ab2APJqD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 04:46:03 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41310 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718Ab2APJqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 04:46:00 -0500
MIME-Version: 1.0
In-Reply-To: <7FE21149F4667147B645348EC60578850910C3@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1326673015-963-1-git-send-email-linus.walleij@stericsson.com>
	<7FE21149F4667147B645348EC60578850910C3@039-SN2MPN1-013.039d.mgd.msft.net>
Date: Mon, 16 Jan 2012 10:46:00 +0100
Message-ID: <CACRpkdaLEasbm-_Vg9VzD+EwwJst1yLQ1sruPaHtFASxcRXXUA@mail.gmail.com>
Subject: Re: [PATCH v3] pinctrl: add support for group and pinmux states
From: Linus Walleij <linus.walleij@linaro.org>
To: Dong Aisheng-B29396 <B29396@freescale.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stephen Warren <swarren@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>,
        Guo Shawn-R65073 <r65073@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 16, 2012 at 9:26 AM, Dong Aisheng-B29396
<B29396@freescale.com> wrote:

> The question is that we allow customer to define pingroup state and this is
> independent on pinctrl core.

You are right, this patch might not be helpful :-(

I had bad dreams after writing it, and I think I also missed Stephens point,
that the pinctrl core should iteratively call the config interface of the
controller while walking a config.

I am authoring a different proposal which is much closer to the pinmux
maps, and thus closer to what you're currently doing with the device
tree bindings and all.

Hold on, hope to post this later today.

Linus Walleij
