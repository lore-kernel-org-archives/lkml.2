Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697Ab2AXDtI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 22:49:08 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:58260 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753637Ab2AXDtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 22:49:06 -0500
X-Sasl-enc: IZy0kYTRw357/Psiwx9ruRrECDLvkmkuAQ0ebFY0ls1X 1327376944
Date: Mon, 23 Jan 2012 19:48:59 -0800
From: Greg KH <greg@kroah.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: netdev@vger.kernel.org, gwingerde@gmail.com, larry.finger@lwfinger.net,
        davem@davemloft.net, bhutchings@solarflare.com, arnd@arndb.de,
        linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH] drivers: misc: Remove MISC_DEVICES config option
Message-ID: <20120124034859.GB17869@kroah.com>
References: <1325796541-11402-1-git-send-email-festevam@gmail.com>
 <20120105223933.GA10268@kroah.com>
 <CAOMZO5BQhcxViN3KnjhzF9hL1w04egkmb9njc7sDUB0GFdgBog@mail.gmail.com>
 <20120106050355.GA7633@kroah.com>
 <CAOMZO5AO8TBm+C8LX97j=0SHUXEfcqb+VykBZhu8-ruazWD_3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOMZO5AO8TBm+C8LX97j=0SHUXEfcqb+VykBZhu8-ruazWD_3A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 24, 2012 at 01:17:44AM -0200, Fabio Estevam wrote:
> On Fri, Jan 6, 2012 at 3:03 AM, Greg KH <greg@kroah.com> wrote:
> 
> > Then remove that selection.  Nothing should be depending on a misc
> > driver,
> 
> Yes, this is the exact issue that this patch tries to solve.

You are seriously going to have to refresh my memory, the patch is many
weeks old, and long gone from my recall.

> Currently all of these are dependent on MISC_DEVICES being set.
> 
> source "drivers/misc/c2port/Kconfig"
> source "drivers/misc/eeprom/Kconfig"
> source "drivers/misc/cb710/Kconfig"
> source "drivers/misc/iwmc3200top/Kconfig"
> source "drivers/misc/ti-st/Kconfig"
> source "drivers/misc/lis3lv02d/Kconfig"
> source "drivers/misc/carma/Kconfig"
> source "drivers/misc/altera-stapl/Kconfig"
> 
> With the patch applied it is possible to select all the drivers above
> and we don't need to select MISC_DEVICES.

Care to add this to the patch description and resend it as I really
don't remember what is going on here.

greg k-h
