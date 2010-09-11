Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203Ab0IKQr0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 12:47:26 -0400
Received: from mail.perches.com ([173.55.12.10]:1682 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752570Ab0IKQrY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 12:47:24 -0400
Subject: Re: [PATCH 1/2] dvb: mantis: use '%pM' format to print MAC address
From: Joe Perches <joe@perches.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>
In-Reply-To: <a548f44961f97f81054fc877aaef068f936c5ca2.1284213506.git.andy.shevchenko@gmail.com>
References: <a548f44961f97f81054fc877aaef068f936c5ca2.1284213506.git.andy.shevchenko@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 11 Sep 2010 09:47:22 -0700
Message-ID: <1284223642.12180.39.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-09-11 at 16:59 +0300, Andy Shevchenko wrote:
>  drivers/media/dvb/mantis/mantis_core.c |    5 +----
>  drivers/media/dvb/mantis/mantis_ioc.c  |    9 +--------

Hi Andy.

I think these are clearer and more commonly used as:

>  	dprintk(verbose, MANTIS_ERROR, 0,
> +		"    MAC Address=[%pM]\n", &mantis->mac_address[0]);

		"    MAC Address=[%pM]\n", mantis->mac_address);

and

> +	dprintk(MANTIS_ERROR, 0, "    MAC Address=[%pM]\n", &mac_addr[0]);

	dprintk(MANTIS_ERROR, 0, "    MAC Address=[%pM]\n", mac_addr);


