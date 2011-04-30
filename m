Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761165Ab1D3BXa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 21:23:30 -0400
Received: from kroah.org ([198.145.64.141]:50302 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756461Ab1D3BX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 21:23:28 -0400
Date: Fri, 29 Apr 2011 18:23:24 -0700
From: Greg KH <greg@kroah.com>
To: johnlinn@comcast.net
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, michal simek <michal.simek@petalogix.com>,
        joe@perches.com, grant likely <grant.likely@secretlab.ca>,
        John Linn <john.linn@xilinx.com>
Subject: Re: [PATCH V5] tty/serial: add support for Xilinx PS UART
Message-ID: <20110430012324.GA12003@kroah.com>
References: <20110430002720.GB1818@kroah.com>
 <297990190.2103989.1304125884176.JavaMail.root@sz0140a.emeryville.ca.mail.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <297990190.2103989.1304125884176.JavaMail.root@sz0140a.emeryville.ca.mail.comcast.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 30, 2011 at 01:11:24AM +0000, johnlinn@comcast.net wrote:
> 
> > On Sat, Apr 30, 2011 at 12:15:54AM +0000, johnlinn@comcast.net wrote:
> > > 
> > > > On Fri, Apr 29, 2011 at 03:59:06PM -0600, johnlinn@comcast.net
> > wrote:
> > > > > From: John Linn <john.linn@xilinx.com>
> > > > > 
> > > > > The Xilinx PS Uart is used on the new ARM based SoC. This
> > > > > UART is not compatible with others such that a seperate
> > > > > driver is required.
> > > > > 
> > > > > Signed-off-by: John Linn <john.linn@xilinx.com>
> > > > 
> > > > That's fine, but:
> > > > 
> > > > > 
> > > > > This email and any attachments are intended for the sole use of
> > the
> > > > named recipient(s) and contain(s) confidential information that
> > may be
> > > > proprietary, privileged or copyrighted under applicable law. If
> > you
> > > > are not the intended recipient, do not read, copy, or forward
> > this
> > > > email message or any attachments. Delete this email message and
> > any
> > > > attachments immediately.
> > > > >
> > > > 
> > > > That means I can't apply this patch :(
> > > > 
> > > > {sigh}
> > > > 
> > > > Please fix this, as it does not allow you to participate in
> > kernel
> > > > development efforts.
> > > 
> > > Sorry for trying your patience, V6 is out and shouldn't have that
> > > nasty issue.
> > > 
> > > Your patience is much appreciated as I'm fighting the good fight
> > with
> > > legal about this and working around it (not real smooth obviously).
> > 
> > You need to do what everyone else does in this situation (Intel,
> > Microsoft, IBM, etc.) and set up a Linux email server somewhere in
> > your
> > company and use it instead, to get your patches out and participate
> > properly in the Linux kernel community.
> > 
> > Sadly, it's quite common to have to do this :(
> 
> I will work on the issue, but since this is ready to go in, I'm going to resend
> V6 from home later if possible to avoid the BS.
> 
> Again, my apologies, I didn't realize it was doing this all along.
> 
> My bosses are asking if there's anything specific in that crap that is the offending
> part such that part of it can be left?  

None of it can be left, sorry.

> I owe you some beer sometime for sure.

I will be glad to take you up on it :)

greg k-h
