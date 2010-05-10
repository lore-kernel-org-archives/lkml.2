Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755629Ab0EJQx6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 12:53:58 -0400
Received: from cantor.suse.de ([195.135.220.2]:59816 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750824Ab0EJQxy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 12:53:54 -0400
Date: Mon, 10 May 2010 09:25:35 -0700
From: Greg KH <gregkh@suse.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Anatolij Gustschin <agust@denx.de>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, leonardo.lists@gmail.com,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] serial: mpc52xx_uart: fix null pointer dereference
Message-ID: <20100510162535.GA15137@suse.de>
References: <g2xc2d0b6ec1005041339r9c40822w7a642f9bba976820@mail.gmail.com>
 <1273011539-13994-1-git-send-email-agust@denx.de>
 <i2xfa686aa41005091504ve2b35a09m23cd2dc13a331f86@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <i2xfa686aa41005091504ve2b35a09m23cd2dc13a331f86@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 10, 2010 at 12:04:30AM +0200, Grant Likely wrote:
> On Wed, May 5, 2010 at 12:18 AM, Anatolij Gustschin <agust@denx.de> wrote:
> > Commit 6acc6833510db8f72b5ef343296d97480555fda9
> > introduced NULL pointer dereference and kernel crash
> > on ppc32 machines while booting. Fix this bug now.
> >
> > Reported-by: Leonardo Chiquitto <leonardo.lists@gmail.com>
> > Signed-off-by: Anatolij Gustschin <agust@denx.de>
> 
> Thanks for being so quick to pick up on this Anatolij.  I've been
> traveling and not able to respond to stuff.  I see that Greg has
> already picked this up (thanks Greg!), but FWIW:
> 
> Acked-by: Grant Likely <grant.likely@secretlab.ca>
> 
> Actually, now that I look, this fix needs to go into Linus' tree right
> away (not just linux-next) since the offending patch went in during
> the 2.6.34 merge window.
> 
> Greg, I can either pick this up and push it out to Linus tomorrow, or
> let you do it.  Whichever you prefer.  Let me know so I don't cause
> conflicts in your tree.

I have 2 other tty/serial fixes to go to Linus for .34 along with this
one, so I'll be glad to send it to him.  I've added your ack to the
patch.

thanks,

greg k-h
