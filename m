Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756615Ab0ICQtR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 12:49:17 -0400
Received: from 29.mail-out.ovh.net ([87.98.216.213]:43471 "HELO
	29.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756520Ab0ICQtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 12:49:15 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Sep 2010 12:49:14 EDT
Date: Fri, 3 Sep 2010 18:41:58 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        bn@niasdigital.com, ryan@bluewatersys.com, david-b@pacbell.net,
        avictor.za@gmail.com
Subject: Re: [PATCH] pio: add arch specific gpio_is_valid() function
Message-ID: <20100903164158.GH17702@game.jcrosoft.org>
References: <20091107122002.1ecf6483@hskinnemoen-d830>
 <1282575669-24501-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282575669-24501-1-git-send-email-nicolas.ferre@atmel.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 2712574351161011052
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17:01 Mon 23 Aug     , Nicolas Ferre wrote:
> Add a simple gpio_is_valid() function to replace
> the standard one. It introduces the __HAVE_ARCH_GPIO_IS_VALID
> macro to overload the generic code.
> As an implementation example, it takes into account the AT91
> pio numbering to check if a proper value is used.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
> Hi all,
> 
> I come back on this thread as I would like to implement the gpio_is_valid()
> function for AT91. I have based this piece of code on comments from Ben and
> Haavard and chose the  __HAVE_ARCH_* macro definition as it seems wide spread
> in kernel code.
> Please make comments and if it is ok for you, eventually accept for merging...
> 
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

specially when the drivers are share between different arch such as here avr32
and arm
but also for renesas between sh and arm and ST between SH and ST200

the representation of an invalid gpio could differ and invalade it dito

Best Regards,
J.
