Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761149Ab1D3BL3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 21:11:29 -0400
Received: from qmta09.emeryville.ca.mail.comcast.net ([76.96.30.96]:48965 "EHLO
	qmta09.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761124Ab1D3BL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 21:11:26 -0400
Date: Sat, 30 Apr 2011 01:11:24 +0000 (UTC)
From: johnlinn@comcast.net
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, michal simek <michal.simek@petalogix.com>,
        joe@perches.com, grant likely <grant.likely@secretlab.ca>,
        John Linn <john.linn@xilinx.com>
Message-ID: <297990190.2103989.1304125884176.JavaMail.root@sz0140a.emeryville.ca.mail.comcast.net>
In-Reply-To: <20110430002720.GB1818@kroah.com>
Subject: Re: [PATCH V5] tty/serial: add support for Xilinx PS UART
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [149.199.62.254]
X-Mailer: Zimbra 6.0.5_GA_2431.RHEL5_64 (ZimbraWebClient - IE8 (Win)/6.0.5_GA_2427.RHEL4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On Sat, Apr 30, 2011 at 12:15:54AM +0000, johnlinn@comcast.net wrote:
> > 
> > > On Fri, Apr 29, 2011 at 03:59:06PM -0600, johnlinn@comcast.net
> wrote:
> > > > From: John Linn <john.linn@xilinx.com>
> > > > 
> > > > The Xilinx PS Uart is used on the new ARM based SoC. This
> > > > UART is not compatible with others such that a seperate
> > > > driver is required.
> > > > 
> > > > Signed-off-by: John Linn <john.linn@xilinx.com>
> > > 
> > > That's fine, but:
> > > 
> > > > 
> > > > This email and any attachments are intended for the sole use of
> the
> > > named recipient(s) and contain(s) confidential information that
> may be
> > > proprietary, privileged or copyrighted under applicable law. If
> you
> > > are not the intended recipient, do not read, copy, or forward
> this
> > > email message or any attachments. Delete this email message and
> any
> > > attachments immediately.
> > > >
> > > 
> > > That means I can't apply this patch :(
> > > 
> > > {sigh}
> > > 
> > > Please fix this, as it does not allow you to participate in
> kernel
> > > development efforts.
> > 
> > Sorry for trying your patience, V6 is out and shouldn't have that
> > nasty issue.
> > 
> > Your patience is much appreciated as I'm fighting the good fight
> with
> > legal about this and working around it (not real smooth obviously).
> 
> You need to do what everyone else does in this situation (Intel,
> Microsoft, IBM, etc.) and set up a Linux email server somewhere in
> your
> company and use it instead, to get your patches out and participate
> properly in the Linux kernel community.
> 
> Sadly, it's quite common to have to do this :(

I will work on the issue, but since this is ready to go in, I'm going to resend
V6 from home later if possible to avoid the BS.

Again, my apologies, I didn't realize it was doing this all along.

My bosses are asking if there's anything specific in that crap that is the offending
part such that part of it can be left?  

I owe you some beer sometime for sure.

Thanks,
John

> 
> thanks,
> 
> greg k-h
