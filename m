Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121Ab0KSRzo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 12:55:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34970 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755999Ab0KSRzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 12:55:43 -0500
Date: Fri, 19 Nov 2010 09:54:43 -0800
From: Greg KH <gregkh@suse.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Pavel Machek <pavel@ucw.cz>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] staging: fix winbond build, needs delay.h
Message-ID: <20101119175443.GA6326@suse.de>
References: <20101119143207.b2d5731e.sfr@canb.auug.org.au>
 <20101119093018.340dab03.randy.dunlap@oracle.com>
 <20101119173831.GA6098@suse.de>
 <4CE6B87C.2010203@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CE6B87C.2010203@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 19, 2010 at 09:48:44AM -0800, Randy Dunlap wrote:
> On 11/19/10 09:38, Greg KH wrote:
> > On Fri, Nov 19, 2010 at 09:30:18AM -0800, Randy Dunlap wrote:
> >> From: Randy Dunlap <randy.dunlap@oracle.com>
> >>
> >> winbond drivers use msleep() and delay(), so include linux/delay.h
> >> in a common header file to prevent build errors.
> >>
> >> drivers/staging/winbond/phy_calibration.c:987: error: implicit declaration of function 'msleep'
> >> drivers/staging/winbond/phy_calibration.c:1556: error: implicit declaration of function 'udelay'
> >> drivers/staging/winbond/reg.c:894: error: implicit declaration of function 'msleep'
> >> drivers/staging/winbond/reg.c:1178: error: implicit declaration of function 'udelay'
> > 
> > Is this error showing up in Linus's tree, or only in linux-next?
> 
> I saw it in linux-next, but it looks like it should also be a build error
> in mainline.

Ok, thanks, I'll queue it up for Linus's tree then.

greg k-h
