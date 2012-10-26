Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933605Ab2JZPCf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 11:02:35 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:35000 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932078Ab2JZPCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 11:02:32 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+dfYy+CpauJjMFetEPE6Y0mHBkiJ4erXs=
Date: Fri, 26 Oct 2012 11:02:06 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>, Ben Dooks <ben-linux@fluff.org>,
        Ian Molton <ian.molton@codethink.co.uk>,
        Nicolas Pitre <nico@fluxnic.net>, Lior Amsalem <alior@marvell.com>,
        Maen Suleiman <maen@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        Shadi Ammouri <shadi@marvell.com>, Eran Ben-Avi <benavi@marvell.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>, Ike Pan <ike.pan@canonical.com>,
        Jani Monoses <jani.monoses@canonical.com>,
        Chris Van Hoof <vanhoof@canonical.com>,
        Dan Frazier <dann.frazier@canonical.com>,
        Leif Lindholm <leif.lindholm@arm.com>, Jon Masters <jcm@redhat.com>,
        David Marlin <dmarlin@redhat.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 2/4] arm: mvebu: adding SATA support: dt binding for
 Armada 370/XP
Message-ID: <20121026150206.GQ18811@titan.lakedaemon.net>
References: <1351254650-26861-1-git-send-email-gregory.clement@free-electrons.com>
 <1351254650-26861-3-git-send-email-gregory.clement@free-electrons.com>
 <20121026133154.GN18811@titan.lakedaemon.net>
 <20121026133446.GM21046@lunn.ch>
 <508A945C.4010006@free-electrons.com>
 <20121026135225.GO21046@lunn.ch>
 <20121026165759.01df4489@skate>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121026165759.01df4489@skate>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2012 at 04:57:59PM +0200, Thomas Petazzoni wrote:
> 
> On Fri, 26 Oct 2012 15:52:25 +0200, Andrew Lunn wrote:
> > > Now, about white spaces vs tab, I don't know what is the rule
> > > for .dts file.
> > 
> > I personally use tabs, but i don't see anything in the
> > Documentation/CodingStyle.
> > 
> > Maybe ask on the device tree mailing list?
> 
> Yes, it would be good to know and document what is the rule for .dts
> files, and possibly extend checkpatch to cover those special rules
> for .dts files.

until that is resolved, can we make this patch conform to what is in the
file currently?  Once the dt folks clarify, we can run through all the
dts's and submit one cleanup series.

If there are no other comments on this series, I'm fine taking it as is
and doing the fixup on my end.  No need to do a version bump just for
this.

thx,

Jason.
