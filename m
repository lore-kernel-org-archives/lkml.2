Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197Ab1KFS1b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 13:27:31 -0500
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:54989 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752933Ab1KFS13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 13:27:29 -0500
X-IronPort-AV: E=Sophos;i="4.69,465,1315173600"; 
   d="scan'208";a="128733458"
Date: Sun, 6 Nov 2011 19:17:34 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Greg Dietsche <Gregory.Dietsche@cuw.edu>
cc: julia@diku.dk, mmarek@suse.cz, rdunlap@xenotime.net, Gilles.Muller@lip6.fr,
        npalix.work@gmail.com, cocci@diku.dk, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RESEND 2/2] coccinelle.txt: update documentation to include M=
 option
In-Reply-To: <1320544784-24576-3-git-send-email-Gregory.Dietsche@cuw.edu>
Message-ID: <alpine.DEB.2.02.1111061917180.1873@hadrien>
References: <1320544784-24576-1-git-send-email-Gregory.Dietsche@cuw.edu> <1320544784-24576-3-git-send-email-Gregory.Dietsche@cuw.edu>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 5 Nov 2011, Gregory.Dietsche@cuw.edu wrote:

> From: Greg Dietsche <Gregory.Dietsche@cuw.edu>
>
> Adding documentation for the new M= option which limits Coccinelle
> to a specific set of directories.
>
> Signed-off-by: Greg Dietsche <Gregory.Dietsche@cuw.edu>

Acked-by: Julia Lawall <julia.lawall@lip6.fr>

> ---
> Documentation/coccinelle.txt |   10 ++++++++--
> 1 files changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/coccinelle.txt b/Documentation/coccinelle.txt
> index 96b6903..cf44eb6 100644
> --- a/Documentation/coccinelle.txt
> +++ b/Documentation/coccinelle.txt
> @@ -102,9 +102,15 @@ or
> 	make coccicheck COCCI=<my_SP.cocci> MODE=report
>
>
> - Using Coccinelle on (modified) files
> -~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> + Controlling Which Files are Processed by Coccinelle
> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> +By default the entire kernel source tree is checked.
> +
> +To apply Coccinelle to a specific directory, M= can be used.
> +For example, to check drivers/net/wireless/ one may write:
>
> +    make coccicheck M=drivers/net/wireless/
> +
> To apply Coccinelle on a file basis, instead of a directory basis, the
> following command may be used:
>
> -- 
> 1.7.6.4
>
>
