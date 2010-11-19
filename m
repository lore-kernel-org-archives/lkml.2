Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036Ab0KSRoM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 12:44:12 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34520 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755658Ab0KSRoK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 12:44:10 -0500
Date: Fri, 19 Nov 2010 09:38:31 -0800
From: Greg KH <gregkh@suse.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Pavel Machek <pavel@ucw.cz>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] staging: fix winbond build, needs delay.h
Message-ID: <20101119173831.GA6098@suse.de>
References: <20101119143207.b2d5731e.sfr@canb.auug.org.au>
 <20101119093018.340dab03.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101119093018.340dab03.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 19, 2010 at 09:30:18AM -0800, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> winbond drivers use msleep() and delay(), so include linux/delay.h
> in a common header file to prevent build errors.
> 
> drivers/staging/winbond/phy_calibration.c:987: error: implicit declaration of function 'msleep'
> drivers/staging/winbond/phy_calibration.c:1556: error: implicit declaration of function 'udelay'
> drivers/staging/winbond/reg.c:894: error: implicit declaration of function 'msleep'
> drivers/staging/winbond/reg.c:1178: error: implicit declaration of function 'udelay'

Is this error showing up in Linus's tree, or only in linux-next?

thanks,

greg k-h
