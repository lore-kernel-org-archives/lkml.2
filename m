Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750890Ab1DGEHF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 00:07:05 -0400
Received: from 63.mail-out.ovh.net ([91.121.185.56]:54447 "HELO
	63.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750702Ab1DGEHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 00:07:04 -0400
Date: Thu, 7 Apr 2011 05:59:14 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: "Justin P. Mattock" <justinmattock@gmail.com>, trivial@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>
Subject: Re: [RFC 1/5]arch/arm/common/Makefile Remove unused config in the
 Makefile.
Message-ID: <20110407035914.GB29567@game.jcrosoft.org>
References: <1302022702-24541-1-git-send-email-justinmattock@gmail.com>
 <20110406080522.GZ13963@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110406080522.GZ13963@pengutronix.de>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 4063372765365185376
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10:05 Wed 06 Apr     , Uwe Kleine-König wrote:
> Hello,
> 
> On Tue, Apr 05, 2011 at 09:58:18AM -0700, Justin P. Mattock wrote:
> > The patch below removes an unused config variable found by using a kernel
> > cleanup script.
> > Note: I did try to cross compile these but hit erros while doing so..
> > (gcc is not setup to cross compile) and am unsure if anymore needs to be done.
> > Please have a look if/when anybody has free time.
> > 
> > Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
> > CC: Russell King <linux@arm.linux.org.uk>
> > CC: linux-arm-kernel@lists.infradead.org
> The file was removed by commit
> 
> 	6d803ba (ARM: 6483/1: arm & sh: factorised duplicated clkdev.c)
> 
> (added the persons involved to Cc).
> 
> Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

Best Regards,
J.
