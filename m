Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933766Ab1D2VfP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 17:35:15 -0400
Received: from qmta12.emeryville.ca.mail.comcast.net ([76.96.27.227]:54047
	"EHLO qmta12.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932208Ab1D2VfO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 17:35:14 -0400
X-Greylist: delayed 349 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Apr 2011 17:35:14 EDT
Date: Fri, 29 Apr 2011 21:29:22 +0000 (UTC)
From: johnlinn@comcast.net
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, michal simek <michal.simek@petalogix.com>,
        joe@perches.com, grant likely <grant.likely@secretlab.ca>,
        John Linn <john.linn@xilinx.com>
Message-ID: <1426670407.2093674.1304112562934.JavaMail.root@sz0140a.emeryville.ca.mail.comcast.net>
In-Reply-To: <20110429211434.GA1355@kroah.com>
Subject: Re: [PATCH V4] tty/serial: add support for Xilinx PS UART
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [149.199.62.254]
X-Mailer: Zimbra 6.0.5_GA_2431.RHEL5_64 (ZimbraWebClient - IE8 (Win)/6.0.5_GA_2427.RHEL4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On Wed, Apr 27, 2011 at 12:17:36PM -0600, johnlinn@comcast.net wrote:
> > From: John Linn <john.linn@xilinx.com>
> > 
> > The Xilinx PS Uart is used on the new ARM based SoC. This
> > UART is not compatible with others such that a seperate
> > driver is required.
> > 
> > Signed-off-by: John Linn <john.linn@xilinx.com>
> 
> I get build failures with this patch:
> 
>   CC [M]  drivers/tty/serial/xilinx_uartps.o
> drivers/tty/serial/xilinx_uartps.c: In function ‘xuartps_get_port’:
> drivers/tty/serial/xilinx_uartps.c:785:14: error: ‘NO_IRQ’ undeclared
> (first use in this function)
> drivers/tty/serial/xilinx_uartps.c:785:14: note: each undeclared
> identifier is reported only once for each function it appears in
> make[1]: *** [drivers/tty/serial/xilinx_uartps.o] Error 1
> 
> Care to fix this up so it's in a state I can properly apply it to the
> tree?

Yes I'll have a look at it, sorry for the hassle.  

I'm assuming I need to try it against linus
tree as something may have changed. Or some other tree?

Thanks,
John

> 
> thanks,
> 
> greg k-h
