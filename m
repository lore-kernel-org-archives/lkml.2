Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760Ab1ISTMs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 15:12:48 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:58080 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774Ab1ISTMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 15:12:47 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Stephen Boyd <sboyd@codeaurora.org>, David Brown <davidb@codeaurora.org>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] msm: platsmp: Mark ioremapped memory as __iomem
Date: Mon, 19 Sep 2011 21:12:08 +0200
Message-ID: <3623124.aFHn2mhMMC@wuerfel>
User-Agent: KMail/4.7.1 (Linux/3.0.0-rc1nosema+; KDE/4.7.1; x86_64; ; )
In-Reply-To: <1316454844-32733-1-git-send-email-sboyd@codeaurora.org>
References: <1316454844-32733-1-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:DZgNRf4cgJuk2aI8PBgufHGW0ViV8NricGB+cbKtEQ6
 fQAEwvTwPIQCDLaiF7lr8+C3sRQrSCqh0frdGPoqkBWpYlgYkx
 zmivILurJli4WqKlO3VChaVKqtupG2Mmxw9ya94EmaqmiI5i2C
 oeBLSy3tMChAAHmYWBUf9AGYOEK3anllCoOxDn0am23IHXLDYG
 GLZdAXOGwQGRpYVJLO6YU5GxW3DD4hYW12aXtRcmoP+yztnvX4
 CazhtA/ZSeemNKAODN4lUQsZ/vqi2W2RSdLW6+Llv/UrxksaCS
 wWYvnjVtK15JzLcy2zOqWJsdUKacOh8+VEDag8HQmZEeul0vT8
 HkQJNNMxVCeekJdhZX4w=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 September 2011 10:54:04 Stephen Boyd wrote:
> Fixes a handful of sparse warnings.
> 
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  arch/arm/mach-msm/platsmp.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Hi Stephen,

This looks good, and I've got a bunch of similar ones in
http://git.linaro.org/gitweb?p=people/arnd/linux.git;a=shortlog;h=refs/heads/randconfig
/msm

Maybe you or David could take a look at those and integrate
them. I was meaning to send them much earlier, but never
get around to actually make sure they are all good.

	arnd
