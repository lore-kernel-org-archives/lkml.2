Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871Ab0IJLH3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 07:07:29 -0400
Received: from 70.mail-out.ovh.net ([91.121.185.63]:55886 "HELO
	70.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752380Ab0IJLH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 07:07:27 -0400
Date: Fri, 10 Sep 2010 13:06:32 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>, avictor.za@gmail.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] AT91: at91sam9261ek board: remove warnings related to
 use of SPI or SD/MMC
Message-ID: <20100910110632.GT9112@game.jcrosoft.org>
References: <1284113629-13768-1-git-send-email-nicolas.ferre@atmel.com>
 <1284113629-13768-2-git-send-email-nicolas.ferre@atmel.com>
 <4C8A07BA.9090805@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C8A07BA.9090805@ru.mvista.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 1255096921826437895
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >   * ADS7846 Touchscreen
> >@@ -357,6 +350,21 @@ static struct spi_board_info ek_spi_devices[] = {
> >  #endif
> >  };
> >
> >+#else /* CONFIG_SPI_ATMEL_* */
> >+
> >+/*
> >+ * MCI (SD/MMC)
> >+ * spi0 and mmc/sd share the same PIO pins: cannot be used at the same time
> >+ */
> >+static struct at91_mmc_data __initdata ek_mmc_data = {
> >+	.wire4		= 1,
> >+//	.det_pin	= ... not connected
> >+//	.wp_pin		= ... not connected
> >+//	.vcc_pin	= ... not connected
> 
>    The coding style document forbids C99 style // comments. Could
> replace with normal comment or #if 0...
no dead code please

Best Regards,
J.
