Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932087Ab1JTJAl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 05:00:41 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:60043 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753610Ab1JTJAk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 05:00:40 -0400
Message-ID: <1319101239.5801.5.camel@Joe-Laptop>
Subject: Re: [patch net-next]alx: Atheros AR8131/AR8151/AR8152/AR8161
 Ethernet driver
From: Joe Perches <joe@perches.com>
To: David Miller <davem@davemloft.net>
Cc: cloud.ren@Atheros.com, Luis.Rodriguez@Atheros.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 20 Oct 2011 02:00:39 -0700
In-Reply-To: <20111020.044541.970282389722164761.davem@davemloft.net>
References: <1319093184-19696-1-git-send-email-cloud.ren@Atheros.com>
	 <20111020.044541.970282389722164761.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-10-20 at 04:45 -0400, David Miller wrote:
> From: <cloud.ren@Atheros.com>
[]
> +#define ALX_HW_WARN(_fmt, _args...) \
> +		ALX_HW_PRINTA(WARNING, _fmt, ## _args)
> +
> +#define ALX_HW_INFO(_fmt, _args...) \
> +		ALX_HW_PRINTA(INFO, _fmt, ## _args)
> +
> +#define ALX_HW_DBG(_fmt, _args...) \
> +		ALX_HW_PRINTA(DEBUG, _fmt, ## _args)
> +

I've just done patches for these
and for ALX_PRINTA and ALX_PRINTB.

I'll send them directly to Cloud.

> Please just submit it to staging and let it cook there for a couple
> weeks in the interests of our sanity.

That's a good plan.

