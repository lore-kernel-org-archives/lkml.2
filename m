Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758766Ab2BJBas (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 20:30:48 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57647 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757901Ab2BJBar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 20:30:47 -0500
Date: Thu, 9 Feb 2012 17:30:41 -0800
From: Dong Aisheng <dongas86@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Barry Song <21cnbao@gmail.com>
Subject: Re: [PATCH] pinctrl: changes hog mechanism to be self-referential
Message-ID: <20120210013041.GA4436@b29396-Latitude-E6410>
References: <1328834868-25030-1-git-send-email-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328834868-25030-1-git-send-email-linus.walleij@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 10, 2012 at 01:47:48AM +0100, Linus Walleij wrote:
> Instead of a specific boolean field to indicate if a map entry shall
> be hogged, treat self-reference as an indication of desired hogging.
> This drops one field off the map struct and has a nice Douglas R.
> Hofstadter-feel to it.
> 
> Suggested-by: Stephen Warren <swarren@nvidia.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  Documentation/pinctrl.txt       |    8 ++++----
>  drivers/pinctrl/core.c          |    6 ++----
>  include/linux/pinctrl/machine.h |   18 ++++++------------
>  3 files changed, 12 insertions(+), 20 deletions(-)
> 

A good cleanup.
Make the next pinctrl core dt binding a little easy for hog things.
Greatly hope this in.

Acked-by: Dong Aisheng <dong.aisheng@linaro.org>

Regards
Dong Aisheng
