Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756503Ab1JTJpl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 05:45:41 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:60289 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756372Ab1JTJpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 05:45:40 -0400
MIME-Version: 1.0
In-Reply-To: <1319062768-26391-3-git-send-email-swarren@nvidia.com>
References: <1319062768-26391-1-git-send-email-swarren@nvidia.com>
	<1319062768-26391-3-git-send-email-swarren@nvidia.com>
Date: Thu, 20 Oct 2011 11:45:39 +0200
Message-ID: <CACRpkdajbtVnia2nUsYBzH5MbeModpAazXyHU5Dm1GPua2QJJg@mail.gmail.com>
Subject: Re: [PATCH 3/4] pinctrl: Don't copy pin names when registering them
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        David Brown <davidb@codeaurora.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rongjun Ying <Rongjun.Ying@csr.com>,
        Linaro Dev <linaro-dev@lists.linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 20, 2011 at 12:19 AM, Stephen Warren <swarren@nvidia.com> wrote:

> A pin controller's names array is no longer marked __refdata. Hence, we
> can avoid copying a pin's name into the descriptor when registering it.
> Instead, just point at the string supplied in the pin array.
>
> This both simplifies and speeds up pin controller initialization, but
> also removes the hard-coded maximum pin name length.
>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

Thanks, applied.
Linus Walleij
