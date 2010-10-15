Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497Ab0JOMbX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 08:31:23 -0400
Received: from 63.mail-out.ovh.net ([91.121.185.56]:57518 "HELO
	63.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755397Ab0JOMbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 08:31:21 -0400
Date: Fri, 15 Oct 2010 14:29:02 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        avictor.za@gmail.com, phorton@bitbox.co.uk
Subject: Re: [PATCH 1/5] Fix AT91SAM9G20 reset as per the errata in the
 data sheet
Message-ID: <20101015122902.GF11127@game.jcrosoft.org>
References: <20100528153725.GA5102@axolotl.localnet>
 <29a192a1f4f98dd05b72ed8eafe67bd6aadd8432.1287076894.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29a192a1f4f98dd05b72ed8eafe67bd6aadd8432.1287076894.git.nicolas.ferre@atmel.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 5302144137882872684
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.500001/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +at91sam9g20_reset:	mov	r0, #0
> +			mcr	p15, 0, r0, c7, c5, 0	@ flush I-cache
do we really need to flush the I-cache again

Best Regards,
J.
