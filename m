Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805Ab0IUPF4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 11:05:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60504 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756151Ab0IUPFz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 11:05:55 -0400
Date: Tue, 21 Sep 2010 17:05:54 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Thomas Weber <weber@corscience.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix typo interrest[ing|ed] => interest[ing|ed]
In-Reply-To: <1284993054-18645-1-git-send-email-weber@corscience.de>
Message-ID: <alpine.LNX.2.00.1009211705470.26813@pobox.suse.cz>
References: <1284993054-18645-1-git-send-email-weber@corscience.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Sep 2010, Thomas Weber wrote:

> Fix typos with interrest*.
> 
> Signed-off-by: Thomas Weber <weber@corscience.de>
> ---
>  drivers/char/stallion.c |    4 ++--
>  drivers/net/wan/hdlc.c  |    2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/char/stallion.c b/drivers/char/stallion.c
> index f2167f8..d7d7d4f 100644
> --- a/drivers/char/stallion.c
> +++ b/drivers/char/stallion.c
> @@ -3180,7 +3180,7 @@ static void stl_cd1400flush(struct stlport *portp)
>  
>  /*
>   *	Return the current state of data flow on this port. This is only
> - *	really interresting when determining if data has fully completed
> + *	really interesting when determining if data has fully completed
>   *	transmission or not... This is easy for the cd1400, it accurately
>   *	maintains the busy port flag.
>   */
> @@ -4130,7 +4130,7 @@ static void stl_sc26198flush(struct stlport *portp)
>  
>  /*
>   *	Return the current state of data flow on this port. This is only
> - *	really interresting when determining if data has fully completed
> + *	really interesting when determining if data has fully completed
>   *	transmission or not... The sc26198 interrupt scheme cannot
>   *	determine when all data has actually drained, so we need to
>   *	check the port statusy register to be sure.
> diff --git a/drivers/net/wan/hdlc.c b/drivers/net/wan/hdlc.c
> index 9937bba..5d4bb61 100644
> --- a/drivers/net/wan/hdlc.c
> +++ b/drivers/net/wan/hdlc.c
> @@ -109,7 +109,7 @@ static int hdlc_device_event(struct notifier_block *this, unsigned long event,
>  		return NOTIFY_DONE; /* not an HDLC device */
>  
>  	if (event != NETDEV_CHANGE)
> -		return NOTIFY_DONE; /* Only interrested in carrier changes */
> +		return NOTIFY_DONE; /* Only interested in carrier changes */
>  
>  	on = netif_carrier_ok(dev);
>  

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
