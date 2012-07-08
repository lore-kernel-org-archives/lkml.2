Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752533Ab2GHWAT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 18:00:19 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:49269 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752564Ab2GHV5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 17:57:48 -0400
Date: Sun, 8 Jul 2012 22:57:12 +0100
From: Will Deacon <will.deacon@arm.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: remove asm/locks.h
Message-ID: <20120708215712.GA6404@mudshark.cambridge.arm.com>
References: <1341262188.1911.147.camel@x61.thuisdomein>
 <20120702215203.GA25234@mudshark.cambridge.arm.com>
 <1341300030.1911.179.camel@x61.thuisdomein>
 <20120708160258.GC27030@mudshark.cambridge.arm.com>
 <1341773106.22584.9.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341773106.22584.9.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 08, 2012 at 07:45:06PM +0100, Paul Bolle wrote:
> On Sun, 2012-07-08 at 17:03 +0100, Will Deacon wrote:
> >  Please can you put this into the patch system?
> 
> I'm not sure what the patch system is, but I am certain that I'm not
> allowed to put this patch into it.

Don't be so certain -- the patch system is the preferred method for submitting
patches to arch/arm/ via Russell's tree. Since you're not familiar with it,
I've sent the patch for you this time:

  http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=7460/1

but if you have any additional patches to core ARM code then you can send
them following mailing list review and looking at the help here:

  http://www.arm.linux.org.uk/developer/patches/info.php

Note that changes to soc-specific code goes via the arm-soc tree (Arnd and
Olof) so don't use the patch system for that.

Cheers,

Will
