Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961Ab0KUCaB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 21:30:01 -0500
Received: from 26.mail-out.ovh.net ([91.121.27.225]:55535 "HELO
	26.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750969Ab0KUCaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 21:30:00 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Sat, 20 Nov 2010 21:29:59 EST
Date: Sun, 21 Nov 2010 03:19:34 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: David Brownell <david-b@pacbell.net>
Cc: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Patrice Vilchez <patrice.vilchez@atmel.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        spi-devel-general@lists.sourceforge.net
Subject: Re: [PATCH 6/6] atmel_spi: fix warning In function
 'atmel_spi_dma_map_xfer'
Message-ID: <20101121021934.GH4216@game.jcrosoft.org>
References: <20101120214820.GG8942@pengutronix.de>
 <616676.83025.qm@web180301.mail.gq1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <616676.83025.qm@web180301.mail.gq1.yahoo.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 9409426998206835648
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14:59 Sat 20 Nov     , David Brownell wrote:
> 
> 
> --- On Sat, 11/20/10, Uwe Kleine-König <u.kleine-koenig@pengutronix.de> wrote:
> 
> > > +        void
> > *nonconst_tx = (void *)xfer->tx_buf; /* shut up gcc */
> 
> Reads like a bad patch to me. Fix the bug,
> don't just silence GCC.  Or at least use
> a better comment mentioning a constness
> cast problems).

ok I change the comment

Best Regards,
J.
