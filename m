Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756735Ab0LRAa3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 19:30:29 -0500
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:25939 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756446Ab0LRAa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 19:30:26 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 24.130.172.179
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/kUCf2QRvri7d7C0cAldmo
Date: Fri, 17 Dec 2010 16:30:22 -0800
From: Tony Lindgren <tony@atomide.com>
To: Carlos Chinea <carlos.chinea@nokia.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [RFC PATCHv4 2/7] HSI: omap_ssi: Introducing OMAP SSI driver
Message-ID: <20101218003022.GB5941@atomide.com>
References: <1292321383-30200-1-git-send-email-carlos.chinea@nokia.com>
 <1292321383-30200-3-git-send-email-carlos.chinea@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292321383-30200-3-git-send-email-carlos.chinea@nokia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Carlos Chinea <carlos.chinea@nokia.com> [101214 02:13]:
> Introduces the OMAP SSI driver in the kernel.
> 
> The Synchronous Serial Interface (SSI) is a legacy version
> of HSI. As in the case of HSI, it is mainly used to connect
> Application engines (APE) with cellular modem engines (CMT)
> in cellular handsets.
> 
> It provides a multichannel, full-duplex, multi-core communication
> with no reference clock. The OMAP SSI block is capable of reaching
> speeds of 110 Mbit/s.
...

> +static int __init ssi_init(void)
> +{
> +	return platform_device_register(&ssi_pdev);
> +}
> +subsys_initcall(ssi_init);

Is this safe to do for all omaps2+ machines?

Regards,

Tony
