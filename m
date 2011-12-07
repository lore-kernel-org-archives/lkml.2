Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757697Ab1LGScs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 13:32:48 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:60595 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757659Ab1LGScq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 13:32:46 -0500
MIME-Version: 1.0
In-Reply-To: <20111207223003.0a0ae278@notabene.brown>
References: <1309427470-605-1-git-send-email-balbi@ti.com>
	<1309427470-605-4-git-send-email-balbi@ti.com>
	<CAMP44s3hFyAK+1W6eU30RNn3=cPDRGKXW+E+sDoWNrNhU0ZpPA@mail.gmail.com>
	<20111207065106.GE32368@legolas.emea.dhcp.ti.com>
	<CAMP44s0psqeMEh8vgYSfV=MAqSOJ6+EpWndXpc89qfGHMX_f=w@mail.gmail.com>
	<20111207223003.0a0ae278@notabene.brown>
Date: Wed, 7 Dec 2011 20:32:46 +0200
Message-ID: <CAMP44s1Smts_TgHhxbdQZS0eM=hwVR8+H2i9AcMEzL_W=Guo6A@mail.gmail.com>
Subject: Re: [regression] Re: [PATCH 3/7] mfd: twl4030-irq: drop the kthread
From: Felipe Contreras <felipe.contreras@gmail.com>
To: NeilBrown <neilb@suse.de>
Cc: balbi@ti.com, Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Tony Lindgren <tony@atomide.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 7, 2011 at 1:30 PM, NeilBrown <neilb@suse.de> wrote:
>  Try the patches I posted to linux-kernel on Nov 27:
>
>   Subject: [PATCH 0/4] fixes for twl4030-irq in mainline
>
> and following
>
>   http://lkml.org/lkml/2011/11/26/92
>
> I think I hit exactly the same bug and you and (eventually) fix it (that was
> a fun learning experience).

Yeap, those patches fix the issue :)

Cheers.

-- 
Felipe Contreras
