Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787Ab1IUQIR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 12:08:17 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:57868 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436Ab1IUQIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 12:08:16 -0400
MIME-Version: 1.0
X-Originating-IP: [93.173.55.223]
In-Reply-To: <CAK=WgbZ_1M-p+BtJnhw_uvaCnLaFRPA_tyv-rSGWMv2GQcB5Cw@mail.gmail.com>
References: <1315846025-11453-1-git-send-email-ohad@wizery.com>
 <CAK=Wgbam6u1bq8fG+oMUhxfWH1g3dU7q+VhPWFEZOLgFMV_3vQ@mail.gmail.com>
 <20110920231340.GT18894@atomide.com> <201109211612.33504.arnd@arndb.de>
 <20110921152812.GE2937@atomide.com> <CAK=WgbZ_1M-p+BtJnhw_uvaCnLaFRPA_tyv-rSGWMv2GQcB5Cw@mail.gmail.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Wed, 21 Sep 2011 19:07:55 +0300
Message-ID: <CAK=WgbZw=q1HkU2U6iuzjSW==za5saFXmnf0yaYoHWkJfduZVA@mail.gmail.com>
Subject: Re: [PATCH 00/10] hwspinlock-next
To: Tony Lindgren <tony@atomide.com>, Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>,
        Greg KH <greg@kroah.com>, Russell King <linux@arm.linux.org.uk>,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Nicolas Pitre <nico@fluxnic.net>, Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 21, 2011 at 6:56 PM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
> On Wed, Sep 21, 2011 at 6:28 PM, Tony Lindgren <tony@atomide.com> wrote:
>> Ohad can you please try this first? Just please make sure your patches are
>> first in next tree before sending in the pull request.
>
> Sure thing.
>
> Stephen, I'll send you the location of my tree in a few.

Just before I do, Tony can I please have your Ack for the mach-omap2
part of this patch-set:

 arch/arm/mach-omap2/hwspinlock.c         |    8 +-

Thanks,
Ohad.
