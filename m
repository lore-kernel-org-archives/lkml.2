Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754359Ab1LMMT2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 07:19:28 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50650 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029Ab1LMMTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 07:19:24 -0500
MIME-Version: 1.0
In-Reply-To: <20111212105650.GA5798@glitch>
References: <1323431857-8828-1-git-send-email-linus.walleij@stericsson.com>
	<20111212105650.GA5798@glitch>
Date: Tue, 13 Dec 2011 13:19:24 +0100
Message-ID: <CACRpkdZsG2zO6DNCrZz3=BReoZLPaGzPtteYvsSvtROCiPw_0Q@mail.gmail.com>
Subject: Re: [PATCH v6] pinctrl: add a pin config interface
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 11:56 AM, Domenico Andreoli <cavokz@gmail.com> wrote:
> On Fri, Dec 09, 2011 at 12:57:37PM +0100, Linus Walleij wrote:

>> -struct pinctrl_dev;
>
> this introduces a warning in case CONFIG_PINCTRL is not enabled.

Uh oh. I've put it back in.

Thanks!
Linus Walleij
