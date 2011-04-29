Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933910Ab1D2Vfc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 17:35:32 -0400
Received: from qmta13.emeryville.ca.mail.comcast.net ([76.96.27.243]:37459
	"EHLO qmta13.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932208Ab1D2Vfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 17:35:31 -0400
Date: Fri, 29 Apr 2011 21:35:28 +0000 (UTC)
From: johnlinn@comcast.net
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org,
        michal simek <michal.simek@petalogix.com>, joe@perches.com,
        grant likely <grant.likely@secretlab.ca>,
        John Linn <john.linn@xilinx.com>
Message-ID: <915452381.2094179.1304112928503.JavaMail.root@sz0140a.emeryville.ca.mail.comcast.net>
In-Reply-To: <681890114.2094084.1304112868616.JavaMail.root@sz0140a.emeryville.ca.mail.comcast.net>
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

Thanks Alan, I'll fix that.  I wanted to make sure I replicated the issue
so I could verify it goes away.
