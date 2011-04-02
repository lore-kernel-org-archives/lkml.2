Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164Ab1DBOMF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 10:12:05 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39934 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123Ab1DBOMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 10:12:03 -0400
Date: Sat, 2 Apr 2011 15:11:34 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Thomas Gleixner <tglx@linutronix.de>, John Stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make clocksource name const
Message-ID: <20110402141134.GA23324@n2100.arm.linux.org.uk>
References: <20110219153450.GI29493@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110219153450.GI29493@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Has this patch been rejected?

On Sat, Feb 19, 2011 at 03:34:50PM +0000, Russell King - ARM Linux wrote:
> As nothing should be writing to the clocksource name string, make the
> clocksource name pointer const.  Build-tested on ARM Versatile Express.
> 
> Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> ---
>  include/linux/clocksource.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
> index c37b21a..94c1f38 100644
> --- a/include/linux/clocksource.h
> +++ b/include/linux/clocksource.h
> @@ -161,7 +161,7 @@ struct clocksource {
>  	/*
>  	 * First part of structure is read mostly
>  	 */
> -	char *name;
> +	const char *name;
>  	struct list_head list;
>  	int rating;
>  	cycle_t (*read)(struct clocksource *cs);
