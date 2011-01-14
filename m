Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547Ab1ANVKJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 16:10:09 -0500
Received: from lo.gmane.org ([80.91.229.12]:45244 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752648Ab1ANVKG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 16:10:06 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Alexander Clouter <alex@digriz.org.uk>
Subject: Re: [PATCHv2] hwrng: add support for picoxcell TRNG
Date: Fri, 14 Jan 2011 20:45:19 +0000
Message-ID: <v7p608-mqv.ln1@chipmunk.wormnet.eu>
References: <20110114181609.GN2822@pulham.picochip.com> <1295030661-16364-1-git-send-email-jamie@jamieiles.com>
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: chipmunk.wormnet.eu
User-Agent: tin/1.9.6-20100522 ("Lochruan") (UNIX) (Linux/2.6.32-5-sparc64-smp (sparc64))
Cc: linux-arm-kernel@lists.infradead.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In gmane.linux.ports.arm.kernel Jamie Iles <jamie@jamieiles.com> wrote:
>
> This driver adds support for the True Random Number Generator in
> the Picochip PC3X3 and later devices.
> 
> [snipped]
>
> +/*
> + * Take the random number generator out of reset and make sure the interrupts
> + * are masked. We shouldn't need to get large amounts of random bytes so just
> + * poll the status register. The hardware generates 32 bits every 320ns so we
> + * shouldn't have to wait long enough to warrant waiting for an IRQ.
> + */
>
timeriomem-rng?  Example of usage in 
arch/arm/mach-orion5x/ts78xx-setup.c.

Cheers

-- 
Alexander Clouter
.sigmonster says: The more I know men the more I like my horse.

