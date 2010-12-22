Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751791Ab0LVByR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 20:54:17 -0500
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:55747 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230Ab0LVByQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 20:54:16 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 24.130.172.179
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+R0doUc1PSdF/jLnVtp7VD
Date: Tue, 21 Dec 2010 17:54:04 -0800
From: Tony Lindgren <tony@atomide.com>
To: Daniel Morsing <daniel.morsing@gmail.com>
Cc: weber@corscience.de, linux@arm.linux.org.uk, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] OMAP2: Devkit8000: Use _cansleep GPIO functions for
 display reset lines
Message-ID: <20101222015404.GO5829@atomide.com>
References: <1292926993.9611.10.camel@morsing>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292926993.9611.10.camel@morsing>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Daniel Morsing <daniel.morsing@gmail.com> [101221 02:22]:
> The display reset lines are connected to a TPS65930 which may sleep
> when changing GPIO values. Use the appropriate function to silence
> a nasty warning from gpiolib.
> 
> Signed-off-by: Daniel Morsing <daniel.morsing@gmail.com>
> Acked-by: Thomas Weber <weber@corscience.de>

Thanks applying.

Tony
