Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932322Ab2LNUFe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 15:05:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44275 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932239Ab2LNUFc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 15:05:32 -0500
Date: Fri, 14 Dec 2012 15:05:19 -0500
From: Dave Jones <davej@redhat.com>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jamie Lentin <jm@lentin.co.uk>, Simon Baatz <gmbnomis@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>
Subject: Re: power: Add simple poweroff-gpio driver
Message-ID: <20121214200519.GA32268@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Jamie Lentin <jm@lentin.co.uk>, Simon Baatz <gmbnomis@gmail.com>,
	Jason Cooper <jason@lakedaemon.net>
References: <20121213202157.8106C66071E@gitolite.kernel.org>
 <20121213205159.GA21825@redhat.com>
 <20121214082150.GA7717@lunn.ch>
 <20121214150841.GA15843@redhat.com>
 <50CB5014.6030004@wwwdotorg.org>
 <20121214195340.GC7717@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121214195340.GC7717@lunn.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2012 at 08:53:40PM +0100, Andrew Lunn wrote:
 > > > I think it needs to be on the menuconfig, rather than the child options.
 > > > I don't have OF_GPIO, but I still got asked for the former.
 > > 
 > > The menuconfig enables a class of drivers (at least theoretically in the
 > > future, when more such drivers turn up), and there's no reason to
 > > believe that all of those drivers will depend on OF. So in my opinion,
 > > making POWER_RESET_GPIO depend on OF makes sense, but making POWER_RESET
 > > depend on it doesn't.
 > 
 > I have another driver coming soon which will not depend on OF_GPIO. It
 > does however depend on OF. Its for a class of boards which have a
 > microcontroller controlling the main power supply, and sending an
 > character over a UART port is used to turn the board power off.
 > 
 > There might also be some legacy drivers which could be moved here
 > which don't depend on OF at all.
 > 
 > So i would prefer to keep POWER_RESET generic.

Perhaps a CONFIG_ARCH_WANT_POWER_RESET option for arches that opt-in ?

	Dave

