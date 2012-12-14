Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932262Ab2LNTxw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 14:53:52 -0500
Received: from londo.lunn.ch ([80.238.139.98]:46581 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756648Ab2LNTxv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 14:53:51 -0500
Date: Fri, 14 Dec 2012 20:53:40 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Dave Jones <davej@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jamie Lentin <jm@lentin.co.uk>, Simon Baatz <gmbnomis@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>
Subject: Re: power: Add simple poweroff-gpio driver
Message-ID: <20121214195340.GC7717@lunn.ch>
References: <20121213202157.8106C66071E@gitolite.kernel.org>
 <20121213205159.GA21825@redhat.com>
 <20121214082150.GA7717@lunn.ch>
 <20121214150841.GA15843@redhat.com>
 <50CB5014.6030004@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50CB5014.6030004@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I think it needs to be on the menuconfig, rather than the child options.
> > I don't have OF_GPIO, but I still got asked for the former.
> 
> The menuconfig enables a class of drivers (at least theoretically in the
> future, when more such drivers turn up), and there's no reason to
> believe that all of those drivers will depend on OF. So in my opinion,
> making POWER_RESET_GPIO depend on OF makes sense, but making POWER_RESET
> depend on it doesn't.

I have another driver coming soon which will not depend on OF_GPIO. It
does however depend on OF. Its for a class of boards which have a
microcontroller controlling the main power supply, and sending an
character over a UART port is used to turn the board power off.

There might also be some legacy drivers which could be moved here
which don't depend on OF at all.

So i would prefer to keep POWER_RESET generic.

      Andrew
