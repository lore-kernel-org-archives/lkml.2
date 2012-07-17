Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886Ab2GQPpd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 11:45:33 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:51749 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751855Ab2GQPpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 11:45:31 -0400
X-Sasl-enc: r5awLoDHeU2xbXbbByyvA7Otp8XD/olktAx1SRayNEhy 1342539930
Date: Tue, 17 Jul 2012 08:45:29 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>
Subject: Re: linux-next: build failure after merge of the tty tree
Message-ID: <20120717154529.GD16283@kroah.com>
References: <20120717134506.3f3f0614ad1d5193689de334@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120717134506.3f3f0614ad1d5193689de334@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2012 at 01:45:06PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> After merging the tty tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> drivers/tty/tty_ioctl.c: In function 'set_sgflags':
> drivers/tty/tty_ioctl.c:741:9: error: request for member 'c_iflag' in something not a structure or union
> drivers/tty/tty_ioctl.c:742:9: error: request for member 'c_oflag' in something not a structure or union
> drivers/tty/tty_ioctl.c:743:9: error: request for member 'c_lflag' in something not a structure or union
> drivers/tty/tty_ioctl.c:745:10: error: request for member 'c_iflag' in something not a structure or union
> drivers/tty/tty_ioctl.c:746:10: error: request for member 'c_lflag' in something not a structure or union
> drivers/tty/tty_ioctl.c:749:10: error: request for member 'c_lflag' in something not a structure or union
> drivers/tty/tty_ioctl.c:753:10: error: request for member 'c_oflag' in something not a structure or union
> drivers/tty/tty_ioctl.c:756:10: error: request for member 'c_iflag' in something not a structure or union
> drivers/tty/tty_ioctl.c:757:10: error: request for member 'c_lflag' in something not a structure or union
> drivers/tty/tty_ioctl.c:759:15: error: request for member 'c_lflag' in something not a structure or union
> drivers/tty/tty_ioctl.c:760:10: error: request for member 'c_cc' in something not a structure or union
> drivers/tty/tty_ioctl.c:761:10: error: request for member 'c_cc' in something not a structure or union
> 
> Caused by commit adc8d746caa6 ("tty: move the termios object into the
> tty").  Did anyone build test this?  :-(

It builds here for me just fine, this is odd.

greg k-h
