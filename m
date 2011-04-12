Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932447Ab1DLUyY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 16:54:24 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:56363 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932227Ab1DLUyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 16:54:22 -0400
Date: Tue, 12 Apr 2011 22:54:21 +0200
From: Cyril Hrubis <metan@ucw.cz>
To: Chris Ball <cjb@laptop.org>
Cc: pavel@ucw.cz, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, eric.y.miao@gmail.com,
        utx@penguin.cz, zaurus-devel@www.linuxtogo.org, marek.vasut@gmail.com,
        linux-mmc@vger.kernel.org
Subject: Re: zaurus: mmcblk0: error -110
Message-ID: <20110412205421.GD2665@atrey.karlin.mff.cuni.cz>
References: <20110412151547.GC20815@atrey.karlin.mff.cuni.cz> <m3aafvz30t.fsf@pullcord.laptop.org> <20110412193944.GC2665@atrey.karlin.mff.cuni.cz> <m3oc4bxne1.fsf@pullcord.laptop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m3oc4bxne1.fsf@pullcord.laptop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
> >> Your symptoms match the bug that was fixed by:
> >> 
> >> bad3babace2ee4d ("mmc: fix CONFIG_MMC_UNSAFE_RESUME regression")
> >> 
> >> but this fix made it into 2.6.38, so if you're using 2.6.38 final then
> >> you shouldn't be seeing this.  Could you confirm that you have this
> >> patch?
> >
> > It seems that the pxa tree I have is still based on 2.6.38-rc8.
> >
> > And yes, turning CONFIG_MMC_UNSAFE_RESUME off seems to fix that problem.
> >
> > I'll try to update the kernel tree and try again with CONFIG_MMC_UNSAFE_RESUME
> > enabled.
> 
> Okay, great.  It was introduced in 2.6.38-rc1 and fixed in 2.6.38 final.
>

Tried 2.6.39-rc3 both with and without CONFIG_MMC_UNSAFE_RESUME and the
insert/remove detection works but both with and without unsafe resume, if the
card is removed for more than second or two it fails to recognize the card
after insertion failing with:

mmc0: error -95 whilst initialising SD card

-- 
metan
