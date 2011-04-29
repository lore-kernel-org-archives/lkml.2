Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933943Ab1D2Vlf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 17:41:35 -0400
Received: from qmta11.emeryville.ca.mail.comcast.net ([76.96.27.211]:60883
	"EHLO qmta11.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933897Ab1D2VlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 17:41:11 -0400
Date: Fri, 29 Apr 2011 21:41:08 +0000 (UTC)
From: johnlinn@comcast.net
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org,
        michal simek <michal.simek@petalogix.com>, joe@perches.com,
        grant likely <grant.likely@secretlab.ca>,
        John Linn <john.linn@xilinx.com>
Message-ID: <1013673718.2094564.1304113268455.JavaMail.root@sz0140a.emeryville.ca.mail.comcast.net>
In-Reply-To: <20110429223222.7d283dde@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH V4] tty/serial: add support for Xilinx PS UART
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [149.199.62.254]
X-Mailer: Zimbra 6.0.5_GA_2431.RHEL5_64 (ZimbraWebClient - IE8 (Win)/6.0.5_GA_2427.RHEL4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > Yes I'll have a look at it, sorry for the hassle.  
> > 
> > I'm assuming I need to try it against linus
> > tree as something may have changed. Or some other tree?
> 
> Or you are assuimg NO_IRQ is defined everywhere which it isn't. The
> kernel mainstream just uses zero as intended not a define for it.
> 
> Alan

Ahh... maybe I see, it's only defined in ARM and that's what I was building
for.  I'm a little slow sometimes, but I'll get there.

Gotcha, replace with 0. Thanks.
