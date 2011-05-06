Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756647Ab1EFQl4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 12:41:56 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50442 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756403Ab1EFQly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 12:41:54 -0400
MIME-Version: 1.0
In-Reply-To: <20110506132344.1d166260@lxorguk.ukuu.org.uk>
References: <1013673718.2094564.1304113268455.JavaMail.root@sz0140a.emeryville.ca.mail.comcast.net>
 <4DC3E580.9090500@petalogix.com> <20110506132344.1d166260@lxorguk.ukuu.org.uk>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 6 May 2011 10:41:34 -0600
X-Google-Sender-Auth: BRtIsuLTC8kXMc5dC1Rr8KkstHM
Message-ID: <BANLkTi=1guAvjXO2FVOPV+4=p53jeU3vUQ@mail.gmail.com>
Subject: Re: [PATCH V4] tty/serial: add support for Xilinx PS UART
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: michal.simek@petalogix.com, johnlinn@comcast.net, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        joe@perches.com, John Linn <john.linn@xilinx.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 6, 2011 at 6:23 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> I don't agree with this change. NO_IRQ for microblaze, arm and other is -1. BTW:
>> For ppc is 0. Using NO_IRQ seems to me reasonable.
>
> 0 means "no interrupt".
>
> The old mis-use of -1 is an old mostly ARM specific ugly that ahould be
> going away not getting repeated further. If Microblaze is using this hack
> then it needs to stop.

This will be easier for microblaze when I finish the irq_domain work.
There are patches on the list, but they need to be reworked before
they are ready for mainline consumption.

g.
