Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124Ab1J1Uic (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 16:38:32 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40672 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755648Ab1J1Uib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 16:38:31 -0400
Date: Fri, 28 Oct 2011 21:37:37 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linus.walleij@linaro.org,
        swarren@nvidia.com, Olof Johansson <olof@lixom.net>,
        Ben Hutchings <ben@decadent.org.uk>,
        "Arnaud Patard (Rtp)" <arnaud.patard@rtp-net.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Wolfram Sang <w.sang@pengutronix.de>, bs14@csr.com
Subject: Re: Zero-length ARM headers in git HEAD
Message-ID: <20111028203737.GA914@flint.arm.linux.org.uk>
References: <4EAB0772.40404@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EAB0772.40404@garzik.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 28, 2011 at 03:50:10PM -0400, Jeff Garzik wrote:
> Gents,
>
> In the following kernel commits,
>
> 	9c587c05d715ca8461342c2cb3b4a67036b5c22b
> 	ea5abbd215b749b2ff14397a47a5e65741c67bf4
> 	cc890cd78acd7ab03442907d354b6af34e973cb3
>
> the file ...$platform/mach/gpio.h is replaced with an empty file.  This  
> disagrees with kernel tradition and kernel makefiles, where zero length  
> files are intentionally deleted when "make distclean" is executed.

It would really help to have a hook in git which catches this at commit
time with a warning (like is possible for whitespace).  At least that
would alert folk to the problem at commit time before stuff has been
published.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
