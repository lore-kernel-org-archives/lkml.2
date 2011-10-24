Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252Ab1JXF5L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 01:57:11 -0400
Received: from 1wt.eu ([62.212.114.60]:34429 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753224Ab1JXF5K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 01:57:10 -0400
Date: Mon, 24 Oct 2011 07:57:05 +0200
From: Willy Tarreau <w@1wt.eu>
To: Roland Kletzing <devzero@web.de>
Cc: linux-kernel@vger.kernel.org, ext-adrian.hunter@nokia.com
Subject: Re: mtd_stresstest module bricked my dockstar
Message-ID: <20111024055705.GA4020@1wt.eu>
References: <69501156.1798237.1319395066798.JavaMail.fmail@mwmweb003>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <69501156.1798237.1319395066798.JavaMail.fmail@mwmweb003>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Roland,

On Sun, Oct 23, 2011 at 08:37:46PM +0200, Roland Kletzing wrote:
> It may be that it`s not recommended or considered "best practise" to load all sorts of unkown modules (i.e. find /lib/modules.... -name "*.ko"....)  - but people do (see https://bugzilla.novell.com/show_bug.cgi?id=224522[https://bugzilla.novell.com/show_bug.cgi?id=224522] ). And it`s not obvious that it`s THAT dangerous. And for me this is the first time Linux REALLY managed to badly brick my hardware in such a rigorous way.  Maybe someone can understand that i`m not really amused, as there is no easy way to recover, as seen on http://www.yourwarrantyisvoid.com/2010/09/08/dead-dockstar-resurrected-with-jtag/[http://www.yourwarrantyisvoid.com/2010/09/08/dead-dockstar-resurrected-with-jtag/] 

If you can't restore it with JTAG, it means the hardware is really dead.
JTAG is used when you blank the flash, and is supposed to work. I don't
know what the module does, but I fail to see how to could wear the flash
that fast. At worst it could have wiped it, or the flash was already bad.

I got one Iomega Iconnect with a faulty flash that I got replaced for a
good one, so it's more likely the case here.

> Luckily, i got that dockstar for cheap and have some more, so let`s call that "shit really happens".
> 
> I don`t want to accuse anybody, that module has it`s purpose, but please consider adding more safeguard against such issues.

I agree with you. I remember the very old ISA NE2000 driver who used to
scan various addresses to find a NIC, causing some of them to reconfigure
their address to *none* and definitely stop responding on the bus to any
reconfiguration request. That was pretty annoying too. After killing a
few, I stopped using Linux on a machine with such a NIC for a long time!

> ps:
> Someone want the Dockstar for spending the hours and the money for debrick ? Or for extracting gold and other precious metals from electronic waste ? ;)

You should keep it and retry the JTAG adapter. You just need a boot loader
so if you manage to find a usable memory location that you can select by
soldering two pins together, you could manage to store it and bood from
another device.

Willy

