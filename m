Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663Ab1KTAoJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 19:44:09 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54959 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751740Ab1KTAoI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 19:44:08 -0500
Date: Sat, 19 Nov 2011 16:35:43 -0800
From: Greg KH <gregkh@suse.de>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dan Delaney <drdelaney@loclhst.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH] usbled: add support for Dream Cheeky DL100B Mailbox
 Friends Alert (1d34:000a)
Message-ID: <20111120003543.GA31706@suse.de>
References: <4EC60E9D.6070606@loclhst.com>
 <alpine.LNX.2.00.1111200007350.15187@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1111200007350.15187@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 20, 2011 at 12:10:10AM +0100, Jiri Kosina wrote:
> On Fri, 18 Nov 2011, Dan Delaney wrote:
> 
> > This patch will add support for the Dream Cheeky Mailbox Friends Alert (http://www.dreamcheeky.com/mailbox-friends-alert) usb led dongle.
> > The drivers for the webmail notifier (1d34:0004) work perfectly fine, so I just would like to add support for the new device.
> > I have tested the patch on gentoo sources of 2.6.39 and 3.0.6, as well as vanilla 3.1.1 and 3.2-rc2.
> > 
> > This is my first attempt at making a change to the kernel, so let me know if I need to change something (formatting, where to post, etc)
> > 
> > I am not sure who else I may need to CC on this.
> 
> Dan,
> 
> thanks for the patch.
> 
> I am adding some more CCs. Greg, it's 50:50 between HID and usbled code, 
> so just let me know whether you'll be taking it or I should take it, 
> either way is fine by me of course.

Looks good to me, feel free to take it and add:
	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

thanks,

greg k-h
