Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758137Ab0HOPjY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 11:39:24 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:35364 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758101Ab0HOPjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 11:39:22 -0400
Date: Sun, 15 Aug 2010 16:38:48 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Claudio Scordino <claudio@evidence.eu.com>
Cc: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Rick Bronson <rick@efn.org>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-serial@vger.kernel.org
Subject: Re: RS485: ioctls defined twice ?
Message-ID: <20100815153848.GA19113@n2100.arm.linux.org.uk>
References: <4C67F815.8020808@evidence.eu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C67F815.8020808@evidence.eu.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 15, 2010 at 04:22:13PM +0200, Claudio Scordino wrote:
> Hi all,
> 
> 	is there any reason why ioctls TIOCGRS485 and TIOCSRS485 are defined

Please wrap your message sensibly so I can see it while replying to you.

> The same happens also for avr32, powerpc and cris (which, however, defines
> 
> Is it duplicated code ?
> 
> Or should these values stay in both asm/ioctls.h and asm-generic/ioctls.h ?

As an exercise to help you answer your own question, please research
how asm-generic/ioctls.h get included on an avr32, powerpc, cris or
ARM kernel build.
