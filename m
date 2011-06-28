Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735Ab1F1UVw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 16:21:52 -0400
Received: from mail.solarflare.com ([216.237.3.220]:10293 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169Ab1F1UVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 16:21:45 -0400
Subject: Re: [PATCH] net/core: Convert to current logging forms
From: Ben Hutchings <bhutchings@solarflare.com>
To: Joe Perches <joe@perches.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Neil Horman <nhorman@tuxdriver.com>, linux-kernel@vger.kernel.org
In-Reply-To: <385ebf7e98e377e6e6c384beb961b65d4a95fb18.1309289792.git.joe@perches.com>
References: <385ebf7e98e377e6e6c384beb961b65d4a95fb18.1309289792.git.joe@perches.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare Communications
Date: Tue, 28 Jun 2011 21:21:41 +0100
Message-ID: <1309292501.2771.48.camel@bwh-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Jun 2011 20:21:44.0411 (UTC) FILETIME=[FF91B2B0:01CC35D0]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.500.1024-18226.005
X-TM-AS-Result: No--4.966700-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-28 at 12:40 -0700, Joe Perches wrote:
> Use pr_fmt, pr_<level>, and netdev_<level> as appropriate.
> 
> Coalesce long formats.
[...]
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -72,6 +72,8 @@
>   *				        - netif_rx() feedback
>   */
>  
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
[...]

KBUILD_MODNAME is presumably going to be "dev".  That's not very
meaningful.

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

