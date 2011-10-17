Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751572Ab1JQL4m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 07:56:42 -0400
Received: from 9.mo1.mail-out.ovh.net ([178.32.108.172]:34185 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751194Ab1JQL4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 07:56:41 -0400
X-Greylist: delayed 3599 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Oct 2011 07:56:41 EDT
Date: Mon, 17 Oct 2011 12:15:32 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Andrew Victor <avictor.za@gmail.com>,
        Maxim Osipov <maxim.osipov@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Andrew Victor <linux@maxim.org.za>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: Re: [PATCH] AT91: Add external RTC for Flexibity board
Message-ID: <20111017101532.GU1459@game.jcrosoft.org>
References: <4DC53134.8070706@gmail.com>
 <20110510234526.GC18929@game.jcrosoft.org>
 <BANLkTikvCiXgnm_hVTqDmzZ6yDf6H5WaCw@mail.gmail.com>
 <20111013211145.GA27779@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111013211145.GA27779@n2100.arm.linux.org.uk>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 433752939927546803
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -210
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeftddrfeeiucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmneculddquddttddmnehlihhnuhigucdlqddutddm
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22:11 Thu 13 Oct     , Russell King - ARM Linux wrote:
> On Wed, May 11, 2011 at 09:44:52AM +0200, Andrew Victor wrote:
> > hi,
> > 
> > >> This patch enables external RTC support on AT91 Flexibity board.
> > 
> > Acked-by: Andrew Victor <linux@maxim.org.za>
> > 
> > Maxim: You can submit it to Russell's patch system.
> > 
> > 
> > > looks fine just one comment please add your board to the new at91sam9260_defconfig
> > 
> > That file does not exist in any mainline kernel.
> 
> It's been a while since this patch went into the patch system, and it
> didn't get applied for various reasons, including because it looked
> like it was sent there without any review (no acked-by's etc added to
> it.)
> 
> What's the status of this - and if its still relevant can we have
> it with the proper attributations please
This patch is already in Arnd tree IIRC

Best Regards,
J.
