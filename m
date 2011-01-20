Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529Ab1ATR4W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 12:56:22 -0500
Received: from mail.perches.com ([173.55.12.10]:3217 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753342Ab1ATR4V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 12:56:21 -0500
Subject: Re: [PATCH v3] net: add Faraday FTMAC100 10/100 Ethernet driver
From: Joe Perches <joe@perches.com>
To: Po-Yu Chuang <ratbert.chuang@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhutchings@solarflare.com, eric.dumazet@gmail.com, dilinger@queued.net,
        Po-Yu Chuang <ratbert@faraday-tech.com>
In-Reply-To: <1295537418-2057-1-git-send-email-ratbert.chuang@gmail.com>
References: <1295256060-2091-1-git-send-email-ratbert.chuang@gmail.com>
	 <1295537418-2057-1-git-send-email-ratbert.chuang@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 Jan 2011 09:56:19 -0800
Message-ID: <1295546179.28001.4.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-20 at 23:30 +0800, Po-Yu Chuang wrote:
> From: Po-Yu Chuang <ratbert@faraday-tech.com>
[]
> +	/* map io memory */
> +	priv->res = request_mem_region(res->start, res->end - res->start,
> +				       dev_name(&pdev->dev));

Off by one?

	priv->res = request_mem_region(res->start, resource_size(res),
				       dev_name(&pdev->dev));



