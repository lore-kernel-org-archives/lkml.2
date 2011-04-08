Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757303Ab1DHOgs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 10:36:48 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50394 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550Ab1DHOgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 10:36:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JYMLVUp62F3jG5LZseBdeuWuj4DnZMf+UwtTTil3udPgzE7VlcIxWTXM3Pg/bVwMAu
         eLock5B60puTnsQGkqqeF3a7ggN9JMFqn82FBkTpC+61hMFFvI5ssUYsNhBe4ZxlT7wE
         AjTPHHXm35A7ZSLJL7FqXiE9CXTfzBFE6Id84=
Date: Fri, 8 Apr 2011 18:36:41 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Jamie Iles <jamie@jamieiles.com>
Cc: linux-kernel@vger.kernel.org, linux@arm.linux.org.uk, tglx@linutronix.de,
        grant.likely@secretlab.ca, arnd@arndb.de, nico@fluxnic.net
Subject: Re: [PATCHv2 6/7] basic_mmio_gpio: support different input/output
 registers
Message-ID: <20110408143641.GA25237@oksana.dev.rtsoft.ru>
References: <1302272211-30242-1-git-send-email-jamie@jamieiles.com>
 <1302272211-30242-7-git-send-email-jamie@jamieiles.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1302272211-30242-7-git-send-email-jamie@jamieiles.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 08, 2011 at 03:16:50PM +0100, Jamie Iles wrote:
[...]
> +	res_in = platform_get_resource_byname(pdev, IORESOURCE_MEM, "in");
> +	if (res_in) {
> +		bgc->reg_in = bgpio_request_and_map(&pdev->dev, res_in);
> +		if (!bgc->reg_in)
> +			return -ENOMEM;
> +		bgc->gc.get = bgpio_get_in;
> +	} else {
> +		bgc->gc.get = bgpio_get_dat;
> +	}
> +
> +	return 0;
> +}
> +
>  	return 0;
>  }

Hm.. will this compile?

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
