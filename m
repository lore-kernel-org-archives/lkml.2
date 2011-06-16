Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758086Ab1FPOJ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 10:09:29 -0400
Received: from 7.27.mail-out.ovh.net ([46.105.34.120]:40162 "HELO
	27.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1757988Ab1FPOJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 10:09:26 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Jun 2011 10:09:26 EDT
Date: Thu, 16 Jun 2011 15:48:46 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Andrew Victor <linux@maxim.org.za>,
        David Woodhouse <dwmw2@infradead.org>,
        Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org
Subject: Re: [PATCH] ATMEL, AVR32: inline nand partition table access
Message-ID: <20110616134846.GF4581@game.jcrosoft.org>
References: <1306676962-22308-1-git-send-email-dbaryshkov@gmail.com>
 <1306935129.1097.3.camel@hcegtvedt.norway.atmel.com>
 <BANLkTi=s4kGg5NKrzNs1nu8S00Ue_Zv8vQ@mail.gmail.com>
 <4DEC8A56.1030707@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DEC8A56.1030707@atmel.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 936467247562140524
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10:05 Mon 06 Jun     , Nicolas Ferre wrote:
> Le 01/06/2011 16:54, Dmitry Eremin-Solenikov :
> > On 6/1/11, Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com> wrote:
> >> On Sun, 2011-05-29 at 17:49 +0400, Dmitry Eremin-Solenikov wrote:
> >>> Currently atmel_nand driver used by AT91 and AVR32 calls a special
> >>> callback
> >>> which return nand partition table and number of partitions. However in all
> >>> boards this callback returns just static data. So drop this callback and
> >>> make atmel_nand use partition table provided statically via platform_data.
> >>>
> >>> Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
> >>
> >> Thanks for this update, always nice seeing code being optimized. I
> >> really can't recall why it was made like this in the first place...
> >>
> >> For the AVR32 related parts:
> >>
> >> Acked-by: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
> >>
> >> <snipp diff>
> >>
> >> Will this go through the linux-mtd tree (since it spans two archs) or
> >> should it go through an arch tree?
> > 
> > On one hand, I'd prefer for this to go through the linux-mtd, if noone objects,
> > as I'd also like to submit several (a pile) patches cleaning up mtd
> > partitioning, which would depend on this.
> > 
> > OTOH, I think there will be a cleanup of AT91 platform, which would bring
> > lot's of conflicts with this patch, if it goes through linux-mtd.
> 
> 
> I am in favor for a mainline inclusion through linux-mtd tree.
> 
> On the AT91 side, we will have to take this inclusion into account to
> avoid merge conflicts... But as long as this cleanup is not ready yet, I
> prefer to go forward this way.
> 
> For that purpose, that would be good to see this patch in linux-next.
agreed

Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

Best Regards,
J.
