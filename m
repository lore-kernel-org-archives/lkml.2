Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952Ab2CVRMO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 13:12:14 -0400
Received: from smtpi4.ngi.it ([88.149.128.104]:48297 "EHLO smtpi4.ngi.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751157Ab2CVRMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 13:12:08 -0400
Message-ID: <4F6B5D5F.90206@denx.de>
Date: Thu, 22 Mar 2012 18:11:59 +0100
From: Stefano Babic <sbabic@denx.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Kyle Manna <kyle.manna@fuel7.com>
CC: Stefano Babic <sbabic@denx.de>, Tony Lindgren <tony@atomide.com>,
        linux-omap@vger.kernel.org, Paul Walmsley <paul@pwsan.com>,
        Kevin Hilman <khilman@ti.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Benoit Cousson <b-cousson@ti.com>, linux-kernel@vger.kernel.org,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: OMAP: Add support for AM35xx UART4/ttyO3
References: <1318963661-27755-1-git-send-email-kyle.manna@fuel7.com> <4F6B4D4A.2040103@denx.de> <4F6B5A90.6030808@fuel7.com>
In-Reply-To: <4F6B5A90.6030808@fuel7.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/03/2012 18:00, Kyle Manna wrote:

> 
> My pin mux is configured in u-boot and is as follows:
> 
>     /* CCDC_FIELD: gpio_95, uP-TXD4 */ \
>     MUX_VAL(CP(CCDC_FIELD),     (IDIS | PTD | DIS | M2)) \
>     /* CCDC_HD: gpio_96, uP-RTS4# */ \
>     MUX_VAL(CP(CCDC_HD),        (IDIS | PTD | DIS | M2)) \
>     /* CCDC_VD: gpio_97, uP-CTS4# */ \
>     MUX_VAL(CP(CCDC_VD),        (IEN  | PTD | EN  | M2)) \
>     /* CCDC_WEN: gpio_98, uP-RXD4 */ \
>     MUX_VAL(CP(CCDC_WEN),       (IEN  | PTD | DIS | M2)) \
> 

Well, we are using the same pins !

> I've just validated my AM3505 board does in fact toggle the TX line and
> writes valid data.  The running kernel is based on a linux-omap-3.1 and
> was the source for that patch.
> 
> Since it sounds like you have the same pinmux, perhaps something changed
> elsewhere in the kernel?

Maybe, but registers looks good - and tracing the serial driver I have
not seen anything wrong.

>  Have you tried validating that your hardware
> can toggle the pin as a GPIO first to eliminate any possibility of shorts?

I will do it now.

Thanks,
Stefano

-- 
=====================================================================
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: +49-8142-66989-53 Fax: +49-8142-66989-80 Email: sbabic@denx.de
=====================================================================
