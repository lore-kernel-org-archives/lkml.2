Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862Ab2GIMuh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 08:50:37 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:20306 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445Ab2GIMug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 08:50:36 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/djWgVBk3xbTivWwXPJDox
Date: Mon, 9 Jul 2012 05:50:25 -0700
From: Tony Lindgren <tony@atomide.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Russell King <linux@arm.linux.org.uk>, Benoit Cousson <b-cousson@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-omap@vger.kernel.org,
        Rajendra Nayak <rnayak@ti.com>, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH 0/7] arm/dts: Audio support for OMAP4 devices (SDP,
 PandaBoard)
Message-ID: <20120709125025.GG1122@atomide.com>
References: <1339164125-32534-1-git-send-email-peter.ujfalusi@ti.com>
 <4FFACC55.4060106@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4FFACC55.4060106@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Ujfalusi <peter.ujfalusi@ti.com> [120709 05:24]:
> Hello,
> 
> On 06/08/2012 04:01 PM, Peter Ujfalusi wrote:
> > Hello,
> > 
> > The following series enable the audio functionality on OMAP4 based devices using
> > twl6040 as audio codec.
> > 
> > The series adds the needed bindings in the dts for the OMAP IPs, twl6040 MFD
> > device and for the audio connection on the board.
> > 
> > To be able to differentiate between PandaBoard and PandaBoardES (they have a bit
> > different audio configuration) a new dts file has been created which only
> > changes the audio properties different between the two boards.
> > 
> > Patches for the drivers involved and the documentation related to dts sections
> > has been either in 3.5 or heading for 3.6.
> 
> Probably this series has been overlooked, since I have not received feedback
> on it.
> Should I resend the series? Which tree should I use to rebase it?

Hmm yeah looks good to me. I guess I was waiting for Benoit to apply or ack
them. I'll apply them into devel-dt branch.

Regards,

Tony
 
> Thank you,
> Péter
> 
> > 
> > Regards,
> > Peter
> > ---
> > Peter Ujfalusi (7):
> >   arm/dts: omap4: Add entry for OMAP McPDM IP
> >   arm/dts: omap4: Add entry for OMAP DMIC IP
> >   arm/dts: omap4-sdp: Add fixed regulator to represent VBAT
> >   arm/dts: omap4-sdp: Add support for twl6040
> >   arm/dts: omap4-sdp: Enable audio support via device tree
> >   arm/dts: omap4-panda: Audio support for PandaBoard 4430
> >   arm/dts: New dts file for PandaBoardES (4460)
> > 
> >  arch/arm/boot/dts/omap4-panda.dts   |   37 +++++++++++++++++++
> >  arch/arm/boot/dts/omap4-pandaES.dts |   24 ++++++++++++
> >  arch/arm/boot/dts/omap4-sdp.dts     |   68 +++++++++++++++++++++++++++++++++++
> >  arch/arm/boot/dts/omap4.dtsi        |   18 +++++++++
> >  4 files changed, 147 insertions(+), 0 deletions(-)
> >  create mode 100644 arch/arm/boot/dts/omap4-pandaES.dts
> > 
> 
> 
