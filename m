Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112Ab2DVONs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 10:13:48 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:48601 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814Ab2DVONr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 10:13:47 -0400
Date: Sun, 22 Apr 2012 15:13:21 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, Alexander Shiyan <shc_work@mail.ru>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/17] ARM clps711x: Added Cirrus Logic EP7312 CPU
	variant
Message-ID: <20120422141321.GI24211@n2100.arm.linux.org.uk>
References: <1334999490-27177-1-git-send-email-shc_work@mail.ru> <201204211211.36273.arnd@arndb.de> <20120421122044.GF24211@n2100.arm.linux.org.uk> <201204221358.29315.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201204221358.29315.arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 22, 2012 at 01:58:28PM +0000, Arnd Bergmann wrote:
> On Saturday 21 April 2012, Russell King - ARM Linux wrote:
> > The headers still have to end up being in an accessible place, and having
> > drivers include the minimum required is a good idea.  Merely moving them
> > into include/mach and updating the include statements as far as I'd go.
> > (and I've never liked the idea of mach/hardware.h being an "include the
> > world for this platform" header file.)
> 
> Digging a bit deeper into clps711x, I found that with Alexander's patch
> series applied, there is nothing that actually includes the three
> asm/hardware/ep7*.h files. I wonder about the motivation behind providing
> them. Any reason we can't just remove those three files altogher?

To me it looks like there isn't anything using any definitions from those
ep721*.h files, so there's little point them existing.  And they've not
changed since 2.6.12-rc2 either...  I'd suggest just getting rid of those
two headers entirely.
