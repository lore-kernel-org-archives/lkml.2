Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269Ab1DVJUh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 05:20:37 -0400
Received: from mail.perches.com ([173.55.12.10]:4912 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752891Ab1DVJUf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 05:20:35 -0400
Subject: Re: [PATCH V2] tty/serial: add support for Xilinx PS UART
From: Joe Perches <joe@perches.com>
To: michal.simek@petalogix.com
Cc: John Linn <john.linn@xilinx.com>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, alan@lxorguk.ukuu.org.uk, greg@kroah.com,
        Grant Likely <grant.likely@secretlab.ca>
In-Reply-To: <4DB14626.8090002@petalogix.com>
References: <90e49570-bc82-41a9-ac79-2f5007e93a2a@VA3EHSMHS018.ehs.local>
	 <4DB14626.8090002@petalogix.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Apr 2011 02:20:33 -0700
Message-ID: <1303464033.26896.11.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-22 at 11:11 +0200, Michal Simek wrote:
> John Linn wrote:
> > The Xilinx PS Uart is used on the new ARM based SoC. This
> > UART is not compatible with others such that a seperate
> > driver is required.
[]
> > +++ b/drivers/tty/serial/xilinx_uartps.c
[]
> > +		rc = uart_add_one_port(&xuartps_uart_driver, port);
> > +		if (rc) {
> > +			dev_err(&pdev->dev, "uart_add_one_port() failed; \
> > +						err=%i\n", rc);

That's a whitespace error.
Please don't be concerned about 80 column lines used for formatting.
You could use something like this as well.

			dev_err(&pdev->dev,
				"uart_add_one_port() failed; err=%d\n", rc);


