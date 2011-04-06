Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574Ab1DFMSP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 08:18:15 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:51896 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339Ab1DFMSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 08:18:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LgEWQ6A1RXTiJwZeizTiQUa+amBwJ+7xQzarl1XDZ8kQ+AdtYsIx5MG5SXYi2MVo1K
         acujv8JeK9/f6PA5u5Efi28LDX41+w3bHZ2v13g/jxzE7Tbv2/L8+/Enf59dCfYlsLHI
         /dy5wGLU2KAbD8uSkYrxajxqUNG5UugeJ0WgY=
Date: Wed, 6 Apr 2011 16:18:09 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Jamie Iles <jamie@jamieiles.com>
Cc: linux-kernel@vger.kernel.org, linux@arm.linux.org.uk, tglx@linutronix.de,
        grant.likely@secretlab.ca, arnd@arndb.de, nico@fluxnic.net
Subject: Re: [RFC PATCH 3/7] basic_mmio_gpio: allow overriding number of
 gpio
Message-ID: <20110406121809.GA8385@oksana.dev.rtsoft.ru>
References: <1302088263-12714-1-git-send-email-jamie@jamieiles.com>
 <1302088263-12714-4-git-send-email-jamie@jamieiles.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1302088263-12714-4-git-send-email-jamie@jamieiles.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 06, 2011 at 12:10:59PM +0100, Jamie Iles wrote:
[...]
> +	if (pdata) {
> +		bgc->gc.base = pdata->base;
> +		if (pdata->ngpio > 0)
> +			ngpio = pdata->ngpio;
> +	} else
> +		bgc->gc.base = -1;

Just a minor comstic nit: 'else' case should be with braces as well.
I.e. '} else {'.

But techincally, the patch looks perfect,

Acked-by: Anton Vorontsov <cbouatmailru@gmail.com>

Thanks,

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
