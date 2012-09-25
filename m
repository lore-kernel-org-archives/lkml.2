Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760Ab2IYKb4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 06:31:56 -0400
Received: from londo.lunn.ch ([80.238.139.98]:44725 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753499Ab2IYKbz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 06:31:55 -0400
Date: Tue, 25 Sep 2012 12:31:41 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Gregory Clement <gregory.clement@free-electrons.com>
Subject: Re: [PATCH 5/6] ARM: dove: Remove watchdog from DT
Message-ID: <20120925103141.GG27099@lunn.ch>
References: <1348531338-16624-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1348531338-16624-6-git-send-email-sebastian.hesselbarth@gmail.com>
 <20120925053542.GK14266@lunn.ch>
 <5061754E.9050204@gmail.com>
 <20120925111826.6f4086ee@skate>
 <20120925094610.GF27099@lunn.ch>
 <20120925121439.49c5d0dd@skate>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120925121439.49c5d0dd@skate>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 12:14:39PM +0200, Thomas Petazzoni wrote:
> Dear Andrew Lunn,
> 
> On Tue, 25 Sep 2012 11:46:10 +0200, Andrew Lunn wrote:
> 
> > I principle, i agree. However, i'm not too sure about mach-orion5x &
> > mach-mv78xx0. orion5x has probably been broken since -rc1 was released
> > and nobody noticed. In the same time, we got around 5 people
> > independently reporting kirkwood was broken. We have not received any
> > new boards for orion5x in the time i've been looking at Orion
> > platforms. mv78xx0 only has one board which is not a Marvell reference
> > design. So im tempted to not spend any effort moving orion5x or
> > mv78xx0 to DT unless these actually hinder the effort of moving the
> > others to DT.  What may make sense is to flatten mv78xx0 and orion5x
> > into plat-orion and then just watch the bit-rot happen.
> 
> I'll try to see if I can get people from LaCie to test mach-orion5x as
> I have a few contacts there, and I'll contact Marvell to see if they can
> still provide Orion-based platforms.

Marvell supplied my one one reference platform. So i can do some
testing that the basic infrastructure works.

But the problem with converting to DT is that there is a lot of
brainless monkey work needed per supported board, and its very easy to
make a typo. So each board converted to DT needs testing. I don't know
if we can find testers for all the boards. But should we throw out
working boards just because we cannot find somebody to test the DT
version?

	Andrew
