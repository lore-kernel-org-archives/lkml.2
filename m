Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478Ab1AGSsq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 13:48:46 -0500
Received: from cantor.suse.de ([195.135.220.2]:32992 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752642Ab1AGSso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 13:48:44 -0500
Date: Fri, 7 Jan 2011 10:37:16 -0800
From: Greg KH <gregkh@suse.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [000/152] 2.6.36.3-stable review
Message-ID: <20110107183716.GA14895@suse.de>
References: <20110106002500.GA3172@kroah.com>
 <20110106134254.68fa27ac@lxorguk.ukuu.org.uk>
 <20110106215705.GA30799@suse.de>
 <20110107150724.GA29082@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110107150724.GA29082@atrey.karlin.mff.cuni.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 07, 2011 at 04:07:24PM +0100, Pavel Machek wrote:
> > On Thu, Jan 06, 2011 at 01:42:54PM +0000, Alan Cox wrote:
> > > On Wed, 5 Jan 2011 16:25:00 -0800
> > > Greg KH <gregkh@suse.de> wrote:
> > > 
> > > > 
> > > > This is the start of the stable review cycle for the 2.6.36.3 release.
> > > > There are 152 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let us know.  If anyone is a maintainer of the proper subsystem, and
> > > > wants to add a Signed-off-by: line to the patch, please respond with it.
> > > 
> > > Look sane on first glance but we don't seem to have a revert for the
> > > serial mess up yet ?
> > > 
> > > > 7a56aa45982bb87bfca98a2832b5ae782c03364a is the first bad commit 
> > > > commit 7a56aa45982bb87bfca98a2832b5ae782c03364a
> > > > Author: Yegor Yefremov <yegor_sub1@visionsystems.de>
> > > > Date:   Wed Jun 16 16:29:55 2010 +0200
> > > > 
> > > >     serial: add UART_CAP_EFR and UART_CAP_SLEEP flags to 16C950 UARTs 
> > > > definition
> > > >     
> > > >     Adding UART_CAP_EFR and UART_CAP_SLEEP flags will enable sleep 
> > > > mode
> > > >     and automatic CTS flow control for 16C950 UARTs. It will also 
> > > > avoid
> > > >     capabilities detection warning like this:
> > > >     
> > > >     "ttyS0: detected caps 00000700 should be 00000100"
> > > >     
> > > >     Signed-off-by: Yegor Yefremov <yegorslists@googlemail.com>
> > > >     Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > > 
> > > 
> > > Has been bisected by several people to be causing failures and reported ?
> > 
> > Hm, I saw Pavel reported a problem, but I didn't get a definate "this
> > must be reverted" resolution from that thread.  It looked like we should
> > just drop one of these flags perhaps?
> > 
> > I can revert it if it really is an issue, but it needs to be reverted in
> > Linus's tree first, before going to stable.
> 
> Flow control flag seems to be responsible.
> 
> But... it hits me and then... me. So I'd like to see it resolved in
> devel tree, but it may not 100% vital for stable.

Ok, care to make up a patch I can apply for Linus's tree first that
works for you?

thanks,

greg k-h
