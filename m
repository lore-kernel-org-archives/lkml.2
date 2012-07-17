Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507Ab2GQPp4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 11:45:56 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:46850 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752168Ab2GQPpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 11:45:54 -0400
X-Sasl-enc: 7SgNCd848RWI/GbwZ52sZipaOy1ckHj58V5ZKK5cGfj0 1342539954
Date: Tue, 17 Jul 2012 08:45:52 -0700
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the tty tree
Message-ID: <20120717154552.GE16283@kroah.com>
References: <20120717134506.3f3f0614ad1d5193689de334@canb.auug.org.au>
 <20120717111053.287191b3@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120717111053.287191b3@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2012 at 11:10:53AM +0100, Alan Cox wrote:
> On Tue, 17 Jul 2012 13:45:06 +1000
> Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> 
> > Hi Greg,
> > 
> > After merging the tty tree, today's linux-next build (powerpc
> > ppc64_defconfig) failed like this:
> > 
> > drivers/tty/tty_ioctl.c: In function 'set_sgflags':
> > drivers/tty/tty_ioctl.c:741:9: error: request for member 'c_iflag' in something not a structure or union
> > drivers/tty/tty_ioctl.c:742:9: error: request for member 'c_oflag' in something not a structure or union
> > drivers/tty/tty_ioctl.c:743:9: error: request for member 'c_lflag' in something not a structure or union
> > drivers/tty/tty_ioctl.c:745:10: error: request for member 'c_iflag' in something not a structure or union
> > drivers/tty/tty_ioctl.c:746:10: error: request for member 'c_lflag' in something not a structure or union
> > drivers/tty/tty_ioctl.c:749:10: error: request for member 'c_lflag' in something not a structure or union
> > drivers/tty/tty_ioctl.c:753:10: error: request for member 'c_oflag' in something not a structure or union
> > drivers/tty/tty_ioctl.c:756:10: error: request for member 'c_iflag' in something not a structure or union
> > drivers/tty/tty_ioctl.c:757:10: error: request for member 'c_lflag' in something not a structure or union
> > drivers/tty/tty_ioctl.c:759:15: error: request for member 'c_lflag' in something not a structure or union
> > drivers/tty/tty_ioctl.c:760:10: error: request for member 'c_cc' in something not a structure or union
> > drivers/tty/tty_ioctl.c:761:10: error: request for member 'c_cc' in something not a structure or union
> > 
> > Caused by commit adc8d746caa6 ("tty: move the termios object into the
> > tty").  Did anyone build test this?  :-(
> 
> It's known not to build. I sent Greg some patches but he wants them
> versus a different tree.

"different tree" == my tree, so I can apply them :)

thanks,

greg k-h
