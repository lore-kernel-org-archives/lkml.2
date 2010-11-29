Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494Ab0K2SA2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 13:00:28 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:35456 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752006Ab0K2SA1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 13:00:27 -0500
Date: Mon, 29 Nov 2010 10:00:04 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Andrea Gelmini <andrea.gelmini@gelma.net>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Daniel Lezcano <daniel.lezcano@free.fr>,
        Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH] init: Kconfig: fix typo
Message-ID: <20101129180004.GB2182@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1290654130-26114-1-git-send-email-andrea.gelmini@gelma.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290654130-26114-1-git-send-email-andrea.gelmini@gelma.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 25, 2010 at 04:02:10AM +0100, Andrea Gelmini wrote:
> s/feautre/feature/

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
> ---
>  init/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/init/Kconfig b/init/Kconfig
> index c972899..dd43d8e 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -620,7 +620,7 @@ config CGROUP_MEM_RES_CTLR_SWAP_ENABLED
>  	help
>  	  Memory Resource Controller Swap Extension comes with its price in
>  	  a bigger memory consumption. General purpose distribution kernels
> -	  which want to enable the feautre but keep it disabled by default
> +	  which want to enable the feature but keep it disabled by default
>  	  and let the user enable it by swapaccount boot command line
>  	  parameter should have this option unselected.
>  	  For those who want to have the feature enabled by default should
> -- 
> 1.7.3.2.316.g4da1c
> 
