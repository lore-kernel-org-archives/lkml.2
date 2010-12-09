Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990Ab0LIQCA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 11:02:00 -0500
Received: from void.printf.net ([89.145.121.20]:46314 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751749Ab0LIQB6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 11:01:58 -0500
Date: Thu, 9 Dec 2010 16:01:57 +0000
From: Chris Ball <cjb@laptop.org>
To: Will Newton <will.newton@gmail.com>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-mmc@vger.kernel.org, Matt Fleming <matt@console-pimps.org>
Subject: Re: [PATCH] dw_mmc: Add Synopsys DesignWare mmc host driver.
Message-ID: <20101209160157.GA28586@void.printf.net>
References: <AANLkTi=0RtvsGX+Q3goL3mdG6oKeNidYtiudTZ8ZTpRP@mail.gmail.com> <20101208115510.GD10998@console-pimps.org> <AANLkTi=KqOa-MRQiptCtZGvoafRCgULfE3QFs=hmGpdi@mail.gmail.com> <AANLkTi=PpTi1_JO9Q=ph7w9Jim8iXMf9LbCfmEkWuo-h@mail.gmail.com> <20101209064751.GA21128@void.printf.net> <AANLkTimMgrawcndvUTYYjq9BGFqs-sbRsZkwVQ0Uvhvb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimMgrawcndvUTYYjq9BGFqs-sbRsZkwVQ0Uvhvb@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Will,

On Thu, Dec 09, 2010 at 12:11:06PM +0000, Will Newton wrote:
> > Is there something we could depend on that would stop this driver being
> > presented to everyone, without being far too specific?  At the moment
> > we'd be making x86 desktop users say whether they have this IP, which
> > isn't good.  Are the architectures that use this IP already upstream?
> > Are they all ARM architectures, for instance?
> 
> I don't know of any architectures upstream that use this IP block. There is an
> SoC from NXP that uses this it but it is not upstream:
> 
> http://ics.nxp.com/support/software/lpc313x.bsp.linux/
> 
> The architecture we tested and debugged this driver on is not upstream either
> unfortunately. :-/

Okay.  I think "depends on ARM" is appropriate for now, and we could
expand that later if the block appears in a MIPS SoC or something.
Does that work for you?

> The driver is available at the link above, I can add the URL to the comment
> if that would be helpful.

Sure, sounds good.

> > Hm, what's the relationship between NXP and Imagination here?  If
> > you're submitting a driver with NXP copyright, I think we should have
> > a Signed-off-by line from whomever owns the copyright/wrote that code.
> > If that's you, that's fine, but it's unclear to me.
> 
> We both have SoCs with this IP block in it, other than that I don't think
> there has been any communication between NXP and Imagination about this driver.
> Hence the lack of SOB from the original authors.
> 
> The driver is available publically under the GPL, so it was my
> understanding that
> no SOB was required as long as we keep appropriate copyright credit in the code.

Okay, makes sense.  Thanks,

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
