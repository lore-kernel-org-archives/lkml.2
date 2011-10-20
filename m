Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756472Ab1JTJmg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 05:42:36 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:53550 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753596Ab1JTJmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 05:42:35 -0400
MIME-Version: 1.0
In-Reply-To: <1319062768-26391-1-git-send-email-swarren@nvidia.com>
References: <1319062768-26391-1-git-send-email-swarren@nvidia.com>
Date: Thu, 20 Oct 2011 11:42:34 +0200
Message-ID: <CACRpkdaAfQv4_jhwc=eTFw2DsG5Ryidkn8Hg85+bAsUbAYmqiQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] pinctrl: get_group_pins() const fixes
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

> get_group_pins() "returns" a pointer to an array of const objects, through
> a pointer parameter. Fix the prototype so what's pointed at by the returned
> pointer is const, rather than the function parameter being const.
>
> This also allows the removal of a cast in each of the two current pinmux
> drivers.
>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

Thanks, applied.
Linus Walleij
