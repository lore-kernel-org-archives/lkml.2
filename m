Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935677Ab2JYNgW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 09:36:22 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:54252 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933157Ab2JYNgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 09:36:21 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/lC9zcoUmYKqocjOjoC6Ox+Zuo9FJuIOA=
Date: Thu, 25 Oct 2012 09:35:56 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Ben Dooks <ben-linux@fluff.org>,
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
Subject: Re: [PATCH 2/2] arm: mvebu: adding SATA support: dt binding and
 config update
Message-ID: <20121025133556.GH18811@titan.lakedaemon.net>
References: <1351086561-13569-1-git-send-email-gregory.clement@free-electrons.com>
 <1351086561-13569-3-git-send-email-gregory.clement@free-electrons.com>
 <20121024160139.6dbf5e16@skate>
 <5087F5B9.0@free-electrons.com>
 <20121025131818.GF18811@titan.lakedaemon.net>
 <20121025152114.73e69c92@skate>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121025152114.73e69c92@skate>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2012 at 03:21:14PM +0200, Thomas Petazzoni wrote:
> Jason,
> 
> On Thu, 25 Oct 2012 09:18:18 -0400, Jason Cooper wrote:
> 
> > > Jason, Andrew, do you want I split this patch as suggested by
> > > Thomas or are you fine with having one single patch?
> > 
> > Yes, please make the defconfig changes a separate patch.  Also, please
> > make sure only the minimum is enabled (eq RAID... isn't needed).
> 
> I haven't looked in details at the driver, but is nr-ports = <foo> the
> right way of doing things? We may have platforms were port 0 is not
> used, but port 1 is used, and just a number of ports doesn't allow to
> express this.

Do you have an example of this?

thx,

Jason.
