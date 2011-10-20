Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756534Ab1JTJoM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 05:44:12 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:54742 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756509Ab1JTJoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 05:44:09 -0400
MIME-Version: 1.0
In-Reply-To: <1319062768-26391-2-git-send-email-swarren@nvidia.com>
References: <1319062768-26391-1-git-send-email-swarren@nvidia.com>
	<1319062768-26391-2-git-send-email-swarren@nvidia.com>
Date: Thu, 20 Oct 2011 11:44:08 +0200
Message-ID: <CACRpkdYuU2=OKs180YJmq+XY6gLS0UVuqYo1Gy7R7ehF6jH5Cw@mail.gmail.com>
Subject: Re: [PATCH 2/4] pinctrl: Remove unsafe __refdata
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

> A pin controller's pin definitions are used both during pinctrl_register()
> and pinctrl_unregister(). The latter happens outside of __init/__devinit
> time, and hence it is unsafe to mark the pin array as __refdata.
>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

Thanks, applied.
Linus Walleij
