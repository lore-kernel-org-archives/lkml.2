Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933580Ab2C2PrT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 11:47:19 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:49303 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932719Ab2C2PrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 11:47:11 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/6WjDJSOpBAvZdNq2/0bWj
Date: Thu, 29 Mar 2012 08:47:06 -0700
From: Tony Lindgren <tony@atomide.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-mtd@lists.infradead.org,
        rmallon@gmail.com, kaloz@openwrt.org, khc@pm.waw.pl,
        alex@digriz.org.uk, nico@fluxnic.net, eric.y.miao@gmail.com,
        haojian.zhuang@gmail.com, marek.vasut@gmail.com,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH 2/5] arm: Use the plat_nand default partition parser
Message-ID: <20120329154706.GU9859@atomide.com>
References: <201203281113.10684.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201203281113.10684.hartleys@visionengravers.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* H Hartley Sweeten <hartleys@visionengravers.com> [120328 11:16]:
> Use the default partition parser, cmdlinepart, provided by the plat_nand driver.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Ryan Mallon <rmallon@gmail.com>
> Cc: Imre Kaloz <kaloz@openwrt.org>
> Cc: Krzysztof Halasa <khc@pm.waw.pl>
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: Alexander Clouter <alex@digriz.org.uk>
> Cc: Nicolas Pitre <nico@fluxnic.net>
> Cc: Eric Miao <eric.y.miao@gmail.com>
> Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
> Cc: Marek Vasut <marek.vasut@gmail.com>

Acked-by: Tony Lindgren <tony@atomide.com>
