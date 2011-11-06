Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166Ab1KFSWs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 13:22:48 -0500
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:65377
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750736Ab1KFSWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 13:22:47 -0500
X-IronPort-AV: E=Sophos;i="4.69,465,1315173600"; 
   d="scan'208";a="117224406"
Date: Sun, 6 Nov 2011 19:19:33 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Greg Dietsche <Gregory.Dietsche@cuw.edu>
cc: julia@diku.dk, Gilles.Muller@lip6.fr, npalix.work@gmail.com,
        mmarek@suse.cz, rdunlap@xenotime.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, cocci@diku.dk
Subject: Re: [RESEND 2/3] coccinelle.txt: add documentation of PARALLEL=
 flag
In-Reply-To: <1320545653-28249-3-git-send-email-Gregory.Dietsche@cuw.edu>
Message-ID: <alpine.DEB.2.02.1111061919230.1873@hadrien>
References: <1320545653-28249-1-git-send-email-Gregory.Dietsche@cuw.edu> <1320545653-28249-3-git-send-email-Gregory.Dietsche@cuw.edu>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 5 Nov 2011, Gregory.Dietsche@cuw.edu wrote:

> From: Greg Dietsche <Gregory.Dietsche@cuw.edu>
>
> Document the new PARALLEL= option of Coccinelle which
> allows running SmPL scripts in parallel.
>
> Signed-off-by: Greg Dietsche <Gregory.Dietsche@cuw.edu>

Acked-by: Julia Lawall <julia.lawall@lip6.fr>

> ---
> Documentation/coccinelle.txt |    6 +++++-
> 1 files changed, 5 insertions(+), 1 deletions(-)
>
> diff --git a/Documentation/coccinelle.txt b/Documentation/coccinelle.txt
> index 9495a4b..3bccb50 100644
> --- a/Documentation/coccinelle.txt
> +++ b/Documentation/coccinelle.txt
> @@ -56,7 +56,7 @@ There are two ways to use Coccinelle with the Linux kernel.
>
> There are a number of optional parameters that can be used with the build target.
>
> -	make coccicheck MODE={patch,report,context,org} COCCI=? M=?
> +	make coccicheck MODE={patch,report,context,org} COCCI=? M=? PARALLEL=?
>
> MODE:
> 	Determines what mode cocci operates in. If no mode is specified
> @@ -71,6 +71,10 @@ M:
> 	Limit cocci to a subset of directories. This is very similar to the
> 	way the build system works when building modules.
>
> +PARALLEL:
> +	Number of *.cocci SmPL scripts found under scripts/coccinelle/ to run
> +	at the same time.
> +
>
>  Using Coccinelle on the Linux kernel
> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> -- 
> 1.7.6.4
>
>
