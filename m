Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759989Ab1D0U5n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 16:57:43 -0400
Received: from qmta05.emeryville.ca.mail.comcast.net ([76.96.30.48]:49466 "EHLO
	qmta05.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752339Ab1D0U5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 16:57:41 -0400
Date: Wed, 27 Apr 2011 20:57:39 +0000 (UTC)
From: johnlinn@comcast.net
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        michal simek <michal.simek@petalogix.com>, joe@perches.com,
        grant likely <grant.likely@secretlab.ca>, greg@kroah.com,
        John Linn <john.linn@xilinx.com>
Message-ID: <2016772931.1967511.1303937859543.JavaMail.root@sz0140a.emeryville.ca.mail.comcast.net>
In-Reply-To: <20110427214045.6f6d179d@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH V4] tty/serial: add support for Xilinx PS UART
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [149.199.62.254]
X-Mailer: Zimbra 6.0.5_GA_2431.RHEL5_64 (ZimbraWebClient - IE8 (Win)/6.0.5_GA_2427.RHEL4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 27 Apr 2011 12:17:36 -0600
> <johnlinn@comcast.net> wrote:
> 
> > From: John Linn <john.linn@xilinx.com>
> > 
> > The Xilinx PS Uart is used on the new ARM based SoC. This
> > UART is not compatible with others such that a seperate
> > driver is required.
> > 
> > Signed-off-by: John Linn <john.linn@xilinx.com>
> 
> Acked-by: Alan Cox <alan@linux.intel.com>

Thanks a bunch Alan, appreciate the help.
