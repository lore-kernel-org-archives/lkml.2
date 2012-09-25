Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809Ab2IYMdP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 08:33:15 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:54877 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469Ab2IYMdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 08:33:14 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Andrew Lunn <andrew@lunn.ch>, sebastien requiem <sebastien@requiem.fr>
Subject: Re: [PATCH 5/6] ARM: dove: Remove watchdog from DT
Date: Tue, 25 Sep 2012 12:33:08 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Olof Johansson <olof@lixom.net>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Gregory Clement <gregory.clement@free-electrons.com>
References: <1348531338-16624-1-git-send-email-sebastian.hesselbarth@gmail.com> <20120925103141.GG27099@lunn.ch> <201209251120.54255.arnd@arndb.de>
In-Reply-To: <201209251120.54255.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209251233.09060.arnd@arndb.de>
X-Provags-ID: V02:K0:s+hUioOXUb3VFHA1uB3aExM98+sbKkd6LZZ0EkCFg9v
 XkMGDNl2PjhMhBpV+k5JeJWn04k/lXiORNYQzWEwWKiLckxakM
 VfIxXp5jMSJ1Psw589Nw1KaG+z5OtReFVn2yhEdB7jeUnB+lf8
 JAxAJbJpzJLJgZKLcdqosgkvRf+Yr8ZBQOtiM4CpRYGe9ShZly
 pc9stZUwKvy2QlGfJACruBMddSx51wtu+khPouiayN16sjGWR+
 IrCiD89YcMgTgy96l8XVXJcR+qQmMcsK7hZ9d/kZu0zb/qP5tS
 ee+3bhSGdoMkc10MSdqK/LuHvJNHQadwtubjWVEPcNFkbrbmeq
 KM1fWVH/BDF+GmMB0SMY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 September 2012, Arnd Bergmann wrote:
> On Tuesday 25 September 2012, Andrew Lunn wrote:
> > > Regarding mv78xx0, I agree that I'm not sure what to do. The number of
> > > supported platforms is small. Should we simply mark mv78xx0 deprecated
> > > now, wait a few release cycles to see if anyone shows up, and see what
> > > to do at this point?
> 
> We should let Sebastien Requiem comment. He is the only person outside of
> Marvell who has contributed a board file for mv78xx0. If he's interested in
> keeping it alive, he's hopefully also able to find the time to test the
> devicetree version of that platform in mach-mvebu. Similarly, if anyone
> has the MASA reference design, that one could be moved over to mach-mvebu
> first.
> 
> There is a much smaller user base for mv78xx0 than for orion5x, so as long
> as we can keep the support working with DT, we can throw out the legacy
> code much faster than for orion. If it doesn't get put into mach-mvebu
> and you can't find anyone who has hardware to test on, you could also
> stop maintaining it and leave it to bitrot, but I wouldn't just remove it
> on a fast track then.

The address I used for Sebastien appears to be dead. Maybe this one still
works.

	Arnd
