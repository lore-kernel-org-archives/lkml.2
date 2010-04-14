Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756399Ab0DNQu4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 12:50:56 -0400
Received: from kroah.org ([198.145.64.141]:33328 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755963Ab0DNQuy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 12:50:54 -0400
Date: Wed, 14 Apr 2010 09:47:02 -0700
From: Greg KH <greg@kroah.com>
To: David Brownell <david-b@pacbell.net>
Cc: Michal Nazarewicz <m.nazarewicz@samsung.com>, linux-usb@vger.kernel.org,
       Peter Korsgaard <jacmet@sunsite.dk>,
       Rupesh Gujare <rupeshgujare@gmail.com>, linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH 7/8] USB: testusb: imported David Brownell's USB
	testing application
Message-ID: <20100414164702.GD6922@kroah.com>
References: <cover.1270644740.git.mina86@mina86.com> <3c4f11cdfb08952e964879c343d6ed7ceedc9542.1270644740.git.mina86@mina86.com> <20100408002952.GC4365@kroah.com> <201004140230.52556.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201004140230.52556.david-b@pacbell.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 14, 2010 at 02:30:52AM -0700, David Brownell wrote:
> On Wednesday 07 April 2010, Greg KH wrote:
> > You should put a:
> > ????????From: David Brownell <dbrownell@users.sourceforge.net>
> > as the first line of the body of this patch, so it properly shows up as
> > David's code.
> > 
> > I also would like to get an ack from David that he doesn't mind his code
> > moving into the kernel here (personally I think it's a good thing to be
> > here.)
> > 
> > thanks,
> 
> ISTR sending an ack .... but, not with a "From:" like that.  I did author the
> code, but the *patch* is not from me.
> 
> 
> Omitting all the instructions and the test plan seems like a big mistake, too...

Agreed, it should be there as well, as you decribed in the follow-on to
the patch.

thanks,

greg k-h
