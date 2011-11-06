Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099Ab1KFSWW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 13:22:22 -0500
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:65357
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750736Ab1KFSWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 13:22:21 -0500
X-Greylist: delayed 313 seconds by postgrey-1.27 at vger.kernel.org; Sun, 06 Nov 2011 13:22:20 EST
X-IronPort-AV: E=Sophos;i="4.69,465,1315173600"; 
   d="scan'208";a="117224360"
Date: Sun, 6 Nov 2011 19:18:59 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Greg Dietsche <Gregory.Dietsche@cuw.edu>
cc: julia@diku.dk, Gilles.Muller@lip6.fr, npalix.work@gmail.com,
        mmarek@suse.cz, rdunlap@xenotime.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, cocci@diku.dk
Subject: Re: [RESEND 1/3] coccinelle.txt: add overview section
In-Reply-To: <1320545653-28249-2-git-send-email-Gregory.Dietsche@cuw.edu>
Message-ID: <alpine.DEB.2.02.1111061918390.1873@hadrien>
References: <1320545653-28249-1-git-send-email-Gregory.Dietsche@cuw.edu> <1320545653-28249-2-git-send-email-Gregory.Dietsche@cuw.edu>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Nov 2011, Gregory.Dietsche@cuw.edu wrote:

> From: Greg Dietsche <Gregory.Dietsche@cuw.edu>
>
> Add an overview section to the coccinelle documentation.
>
> Signed-off-by: Greg Dietsche <Gregory.Dietsche@cuw.edu>
> Signed-off-by: Nicolas Palix <npalix.work@gmail.com>

Acked-by: Julia Lawall <julia.lawall@lip6.fr>

> ---
> Documentation/coccinelle.txt |   31 +++++++++++++++++++++++++++++++
> 1 files changed, 31 insertions(+), 0 deletions(-)
>
> diff --git a/Documentation/coccinelle.txt b/Documentation/coccinelle.txt
> index 96b6903..9495a4b 100644
> --- a/Documentation/coccinelle.txt
> +++ b/Documentation/coccinelle.txt
> @@ -41,6 +41,37 @@ The semantic patches in the kernel will work best with Coccinelle version
> semantic patch code, but any results that are obtained should still be
> correct.
>
> +
> + Overview / Quick Start
> +~~~~~~~~~~~~~~~~~~~~~~~~
> +
> +There are two ways to use Coccinelle with the Linux kernel.
> +
> +1) Coccinelle can be used like sparse (see Documentation/sparse.txt):
> +	make C=1 CHECK="scripts/coccicheck"
> +	make C=2 CHECK="scripts/coccicheck"
> +
> +2) Coccinelle can be used via a build target in the kernel's Makefile:
> +	make coccicheck
> +
> +There are a number of optional parameters that can be used with the build target.
> +
> +	make coccicheck MODE={patch,report,context,org} COCCI=? M=?
> +
> +MODE:
> +	Determines what mode cocci operates in. If no mode is specified
> +	then cocci will default to 'chain' mode which will run for each
> +	available mode (patch, report, context, org).
> +
> +COCCI:
> +	Process a specific .cocci SmPL script. If this is not set then
> +	process all scripts under scripts/coccinelle/
> +
> +M:
> +	Limit cocci to a subset of directories. This is very similar to the
> +	way the build system works when building modules.
> +
> +
>  Using Coccinelle on the Linux kernel
> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>
> -- 
> 1.7.6.4
>
>
