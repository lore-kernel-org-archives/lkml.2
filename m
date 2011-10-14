Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634Ab1JNNkf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 09:40:35 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:38115 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528Ab1JNNkd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 09:40:33 -0400
MIME-Version: 1.0
In-Reply-To: <1318595400.6132.73.camel@x61.thuisdomein>
References: <1318595400.6132.73.camel@x61.thuisdomein>
Date: Fri, 14 Oct 2011 09:40:33 -0400
Message-ID: <CA+5PVA5T+XqY8CxoK7+_s0F6FPW+ey2tAssEHMOi7M4vHph+tA@mail.gmail.com>
Subject: Re: [PATCH 15/21] powerpc: drop unused Kconfig symbols
From: Josh Boyer <jwboyer@gmail.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Matt Porter <mporter@kernel.crashing.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 14, 2011 at 8:30 AM, Paul Bolle <pebolle@tiscali.nl> wrote:
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
>  arch/powerpc/Kconfig                       |   22 ----------------------
>  arch/powerpc/platforms/40x/Kconfig         |    5 -----
>  arch/powerpc/platforms/Kconfig.cputype     |    8 --------
>  arch/powerpc/platforms/embedded6xx/Kconfig |    4 ----
>  arch/powerpc/platforms/prep/Kconfig        |    9 ---------
>  arch/powerpc/platforms/wsp/Kconfig         |    5 -----
>  6 files changed, 0 insertions(+), 53 deletions(-)

For the 40x change:

Acked-by: Josh Boyer <jwboyer@gmail.com>

josh

> diff --git a/arch/powerpc/platforms/40x/Kconfig b/arch/powerpc/platforms/40x/Kconfig
> index d733d7c..4bd3a27 100644
> --- a/arch/powerpc/platforms/40x/Kconfig
> +++ b/arch/powerpc/platforms/40x/Kconfig
> @@ -115,11 +115,6 @@ config PPC40x_SIMPLE
>        help
>          This option enables the simple PowerPC 40x platform support.
>
> -# 40x specific CPU modules, selected based on the board above.
> -config NP405H
> -       bool
> -       #depends on ASH
> -
>  # OAK doesn't exist but wanted to keep this around for any future 403GCX boards
>  config 403GCX
>        bool
>
