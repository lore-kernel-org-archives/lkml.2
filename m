Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932567Ab1EYUs2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 16:48:28 -0400
Received: from cantor.suse.de ([195.135.220.2]:38516 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756382Ab1EYUs0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 16:48:26 -0400
Message-ID: <4DDD6B59.9000108@suse.cz>
Date: Wed, 25 May 2011 22:49:29 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org
Subject: Re: [PATCH 28/34] atm: Drop __TIME__ usage
References: <1302015561-21047-1-git-send-email-mmarek@suse.cz> <1302015561-21047-29-git-send-email-mmarek@suse.cz>
In-Reply-To: <1302015561-21047-29-git-send-email-mmarek@suse.cz>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 5.4.2011 16:59, Michal Marek napsal(a):
> The kernel already prints its build timestamp during boot, no need to
> repeat it in random drivers and produce different object files each
> time.
> 
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Michal Marek <mmarek@suse.cz>
> ---
>  net/atm/lec.c |    2 +-
>  net/atm/mpc.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

Hi,

I don't see this patch in today's linux-next. Any objection against me
applying it to the kbuild-2.6.git repository?

Thanks,
Michal


> diff --git a/net/atm/lec.c b/net/atm/lec.c
> index 38754fd..cb14ddf 100644
> --- a/net/atm/lec.c
> +++ b/net/atm/lec.c
> @@ -1173,7 +1173,7 @@ static int __init lane_module_init(void)
>  #endif
>  
>  	register_atm_ioctl(&lane_ioctl_ops);
> -	pr_info("lec.c: " __DATE__ " " __TIME__ " initialized\n");
> +	pr_info("lec.c: initialized\n");
>  	return 0;
>  }
>  
> diff --git a/net/atm/mpc.c b/net/atm/mpc.c
> index 644cdf0..3ccca42 100644
> --- a/net/atm/mpc.c
> +++ b/net/atm/mpc.c
> @@ -1482,7 +1482,7 @@ static __init int atm_mpoa_init(void)
>  	if (mpc_proc_init() != 0)
>  		pr_info("failed to initialize /proc/mpoa\n");
>  
> -	pr_info("mpc.c: " __DATE__ " " __TIME__ " initialized\n");
> +	pr_info("mpc.c: initialized\n");
>  
>  	return 0;
>  }

