Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036Ab0KUVof (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 16:44:35 -0500
Received: from thunk.org ([69.25.196.29]:41398 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755838Ab0KUVoe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 16:44:34 -0500
Date: Sun, 21 Nov 2010 16:44:07 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        "Perez-Gonzalez, Inaky" <inaky.perez-gonzalez@intel.com>,
        Charles Marker <Charles.Marker@atheros.com>,
        Jouni Malinen <Jouni.Malinen@atheros.com>,
        Kevin Hayes <kevin@atheros.com>, Zhifeng Cai <zhifeng.cai@atheros.com>,
        Don Breslin <Don.Breslin@atheros.com>,
        Doug Dahlby <Doug.Dahlby@atheros.com>, Julia Lawall <julia@diku.dk>
Subject: Re: Challenges with doing hardware bring up with Linux first
Message-ID: <20101121214407.GH23423@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	David Miller <davem@davemloft.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Stephen Hemminger <shemminger@vyatta.com>,
	"Perez-Gonzalez, Inaky" <inaky.perez-gonzalez@intel.com>,
	Charles Marker <Charles.Marker@atheros.com>,
	Jouni Malinen <Jouni.Malinen@atheros.com>,
	Kevin Hayes <kevin@atheros.com>,
	Zhifeng Cai <zhifeng.cai@atheros.com>,
	Don Breslin <Don.Breslin@atheros.com>,
	Doug Dahlby <Doug.Dahlby@atheros.com>, Julia Lawall <julia@diku.dk>
References: <AANLkTim4jVaZxYp8nSgJyy28iwxcxbPeNUzxTfoHAX4S@mail.gmail.com>
 <F46C52ED-8DB8-4347-957D-B9D84406D53F@mit.edu>
 <AANLkTinyafwe9MyXhSSe5vxEKnTUeLV0AZDWY_uXsu8f@mail.gmail.com>
 <20101121130236.GE23423@thunk.org>
 <20101121172906.GD3703@kroah.com>
 <AANLkTik6MQjYTCQ4wtyRpOGb94uyUTA+juvX-8UsP95J@mail.gmail.com>
 <20101121203124.1ba8212e@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101121203124.1ba8212e@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 21, 2010 at 08:31:24PM +0000, Alan Cox wrote:
> 
> Which we know in practice they won't. They'll sit on fixes (often
> security fixes) and tweak and add private copies of features. In turn the
> Linux one could then only keep up by adding features itself - which would
> have to be GPL to stop the same abuse continuing.
> 
> It's a nice idea but the corporations exist to make money and adding
> proprietary custom stack add-ons is clearly a good move on their part to
> do that.

Hence my recommendation that if someone is going to do the work to
create a 802.11 layer that has shims that work on multiple operating
systems, it be GPL with explicit exceptions to allow said layer to
work on legacy operating systems like QNX, et. al.  That way it forces
the hardware specific code to be released under the GPL --- if they
want to take advantage of the "write onces, work on multiple operating
systems" feature.

If someone is going to go through all of this work to make it possible
--- particularly if it's at a company such as Luis's employer, or any
other wifi chipset provider --- why should it allow their competitors
to do closed source drivers?  Better to structure the driver licensing
such that (a) there is benefit for companies to make a Linux driver by
using this common stack, and (b) but in exchange, it forces them to
make a driver which is guaranteed to be usable by Linux by virtual of
the fact that (1) the native interface is Linux's wireless stack, and
(2) the license forces them to GPL their driver. 

    		       	       	   - Ted
