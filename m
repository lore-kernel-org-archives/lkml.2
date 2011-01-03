Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932299Ab1ACPKy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 10:10:54 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46933 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932288Ab1ACPKx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 10:10:53 -0500
Date: Mon, 3 Jan 2011 16:10:51 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        gregkh@suse.de
Subject: Re: [PATCH 1/5]arch:powerpc:platforms:85xx:mpc85xx_mds.c Typo change
 singal to signal
In-Reply-To: <1293754184-1928-1-git-send-email-justinmattock@gmail.com>
Message-ID: <alpine.LNX.2.00.1101031610420.26685@pobox.suse.cz>
References: <1293754184-1928-1-git-send-email-justinmattock@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Dec 2010, Justin P. Mattock wrote:

> The patches below fixes a typo "singal" to "signal". Please let me 
> know if anything needs to be changed.
> 
> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
> 
> ---
>  arch/powerpc/platforms/85xx/mpc85xx_mds.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/powerpc/platforms/85xx/mpc85xx_mds.c b/arch/powerpc/platforms/85xx/mpc85xx_mds.c
> index aa34cac..747d1ee 100644
> --- a/arch/powerpc/platforms/85xx/mpc85xx_mds.c
> +++ b/arch/powerpc/platforms/85xx/mpc85xx_mds.c
> @@ -309,7 +309,7 @@ static void __init mpc85xx_mds_qe_init(void)
>  			/* P1021 has pins muxed for QE and other functions. To
>  			 * enable QE UEC mode, we need to set bit QE0 for UCC1
>  			 * in Eth mode, QE0 and QE3 for UCC5 in Eth mode, QE9
> -			 * and QE12 for QE MII management singals in PMUXCR
> +			 * and QE12 for QE MII management signals in PMUXCR
>  			 * register.
>  			 */

Applied.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
