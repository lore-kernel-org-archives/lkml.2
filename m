Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751350Ab1IXFsp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Sep 2011 01:48:45 -0400
Received: from 6.mo1.mail-out.ovh.net ([46.105.43.205]:34849 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750887Ab1IXFso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Sep 2011 01:48:44 -0400
Date: Sat, 24 Sep 2011 07:26:09 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Josh Wu <josh.wu@atmel.com>, nicolas.ferre@atmel.com,
        linux-kernel@vger.kernel.org, s.nawrocki@samsung.com,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: Re: [PATCH v3 2/2] at91: add Atmel ISI and ov2640 support on
 sam9m10/sam9g45 board.
Message-ID: <20110924052609.GI29998@game.jcrosoft.org>
References: <1316664661-11383-1-git-send-email-josh.wu@atmel.com>
 <1316664661-11383-2-git-send-email-josh.wu@atmel.com>
 <Pine.LNX.4.64.1109220911500.11164@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1109220911500.11164@axis700.grange>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 8014437012489349895
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -200
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeftddrfeeiucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmneculddquddttddm
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09:35 Thu 22 Sep     , Guennadi Liakhovetski wrote:
> On Thu, 22 Sep 2011, Josh Wu wrote:
> 
> > This patch
> > 1. add ISI_MCK parent setting code when add ISI device.
> > 2. add ov2640 support on board file.
> > 3. define isi_mck clock in sam9g45 chip file.
> > 
> > Signed-off-by: Josh Wu <josh.wu@atmel.com>
> > ---
> >  arch/arm/mach-at91/at91sam9g45.c         |    3 +
> >  arch/arm/mach-at91/at91sam9g45_devices.c |  105 +++++++++++++++++++++++++++++-
> >  arch/arm/mach-at91/board-sam9m10g45ek.c  |   85 ++++++++++++++++++++++++-
> >  arch/arm/mach-at91/include/mach/board.h  |    3 +-
> 
> Personally, I think, it would be better to separate this into two patches 
> at least: one for at91 core and one for the specific board, but that's up 
> to arch maintainers to decide.
> 
> You also want to patch arch/arm/mach-at91/at91sam9263_devices.c, don't 
> you?
agreed

Best Regards,
J.
