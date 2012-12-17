Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360Ab2LQSCs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 13:02:48 -0500
Received: from antcom.de ([188.40.178.216]:55293 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752478Ab2LQSCr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 13:02:47 -0500
Message-ID: <50CF5E45.5030104@antcom.de>
Date: Mon, 17 Dec 2012 19:02:45 +0100
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.11) Gecko/20121123 Icedove/10.0.11
MIME-Version: 1.0
To: Wolfgang Grandegger <wg@grandegger.com>
CC: rmallon@gmail.com, gregkh@linuxfoundation.org, linus.walleij@linaro.org,
        broonie@opensource.wolfsonmicro.com, w.sang@pengutronix.de,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        daniel-gl@gmx.net, sr@denx.de, plagnioj@jcrosoft.com,
        linux-arm-kernel@lists.infradead.org, highguy@gmail.com
Subject: Re: [PATCH RESEND 0/6 v10] gpio: Add block GPIO
References: <1355495185-24220-1-git-send-email-stigge@antcom.de> <50CB68AB.5070806@grandegger.com> <50CBBB25.20002@antcom.de> <50CF03FB.2030100@grandegger.com> <50CF0744.7040404@grandegger.com> <50CF1EF1.2070601@antcom.de> <50CF237E.5020409@antcom.de> <50CF4838.9000401@grandegger.com> <50CF5327.6070205@antcom.de> <50CF584E.1040601@grandegger.com>
In-Reply-To: <50CF584E.1040601@grandegger.com>
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2012 06:37 PM, Wolfgang Grandegger wrote:
> 	/* Do synchronous data output with a single write access */
> 	__raw_writel(~mask, pio + PIO_OWDR);
> 	__raw_writel(mask, pio + PIO_OWER);
> 	__raw_writel(val, pio + PIO_ODSR);
> 
> For caching we would need a storage. Not sure if it's worth compared to
> a context switch into the kernel.

Block GPIO is not only for you in userspace. ;-) You can also implement
efficient n-bit bus I/O in kernel drivers, n-bit-banging. :-) So not
always context switches involved.

Roland
