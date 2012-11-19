Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757Ab2KSUAt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 15:00:49 -0500
Received: from mail.kernel.org ([198.145.19.201]:50545 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754113Ab2KSUAs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 15:00:48 -0500
Date: Mon, 19 Nov 2012 12:01:49 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Bill Pemberton <wfp5p@virginia.edu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 000/493] remove CONFIG_HOTPLUG as an option
Message-ID: <20121119200149.GA31589@kroah.com>
References: <1353112043-11800-1-git-send-email-wfp5p@virginia.edu>
 <20121119195555.GA21922@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121119195555.GA21922@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2012 at 11:55:56AM -0800, Dmitry Torokhov wrote:
> On Fri, Nov 16, 2012 at 07:19:10PM -0500, Bill Pemberton wrote:
> > CONFIG_HOTPLUG is no longer an optional setting.  In order to remove
> > it as on option code paths that check CONFIG_HOTPLUG will removed
> > along with the attributes __devexit_p, __devexit, __devinitconst, and
> > __devinitdata.
> > 
> > I'll save the list from the mailbomb of this huge patchset.  The
> > patches themselves are going to Greg KH for the driver core tree.
> > 
> 
> _iff_ we are going to do this I'd prefer pushing input pieces through my
> tree to limit clashes with other work.

That's fine with me.  I'll ignore any drivers/input/ patches then, is
that ok?

thanks,

greg k-h
