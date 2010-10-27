Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761253Ab0J0N1p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 09:27:45 -0400
Received: from gate.crashing.org ([63.228.1.57]:57478 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756640Ab0J0N1m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 09:27:42 -0400
Subject: Re: Pegasos OHCI bug (was Re: PROBLEM: memory corrupting bug,
 bisected to 6dda9d55)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: pacman@kosh.dhis.org
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        matt@genesi-usa.com
In-Reply-To: <20101027085738.1837.qmail@kosh.dhis.org>
References: <20101027085738.1837.qmail@kosh.dhis.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Oct 2010 00:27:24 +1100
Message-ID: <1288186044.2236.25.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Since then, the silence has been deafening.
> 
> My assumption now is that this is not ever getting fixed. I'm certainly not
> able to fix it. I'm not a even kernel programmer! I got far enough to
> diagnose the cause just with the "add more printk's and boot it again"
> technique. Hundreds of reboots trying to figure it out. I was a conscientious
> bug-reporter, I thought.

I'm happy to help you fix it but I'm travelling at the moment and won't
have much time for a couple of weeks.

Cheers,
Ben.

> I could pull the PCI card and be done with it. I never used those USB ports
> anyway. But after all the suffering I went through to find this bug... the
> crashing e2fsck's and consequent filesystem corruption... I hate the idea of
> surrendering to it. There are possibly other affected users who I'd be
> abandoning to suffer similarly in the future.
> 
> For the last week I've studied OpenFirmware as hard as I can. I read the spec
> cover to cover. And the USB annex, and the PCI annex. But I'm still lost in
> all the different address formats.
> 
> I took my best guess on how to handle this problem, and ran with it, ending
> up with a 97-line Forth script, and that was just to get a virtual address,
> not to actually do anything with it, and it used a hardcoded device path. But
> it didn't work, all I got was an "invalid pointer" error. I made another
> guess at something that wasn't documented anywhere (the fact that this stuff
> is insufficiently documented is the one thing I can state with complete
> confidence!) and out came a successful translation to a virtual address: 0.
> 
> If I'm the only one fighting this bug, the bug wins.
> 


