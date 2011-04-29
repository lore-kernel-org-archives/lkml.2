Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933936Ab1D2WCp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 18:02:45 -0400
Received: from qmta07.emeryville.ca.mail.comcast.net ([76.96.30.64]:50779 "EHLO
	qmta07.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758088Ab1D2WCo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 18:02:44 -0400
Date: Fri, 29 Apr 2011 22:02:39 +0000 (UTC)
From: johnlinn@comcast.net
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, michal simek <michal.simek@petalogix.com>,
        joe@perches.com, grant likely <grant.likely@secretlab.ca>,
        John Linn <john.linn@xilinx.com>
Message-ID: <1369027353.2095897.1304114559625.JavaMail.root@sz0140a.emeryville.ca.mail.comcast.net>
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
> 
> thanks,
> 
> greg k-h

Done and sent out as V5 of patch.

Just for future reference (and maybe I should know this).  How should I 
have prevented this problem? I guess I would need to build the kernel 
for other architectures and I don't normally do that.

Thanks,
John
