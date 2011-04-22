Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755599Ab1DVNkN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 09:40:13 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:24021
	"EHLO VA3EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755368Ab1DVNkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 09:40:11 -0400
X-SpamScore: -29
X-BigFish: VPS-29(zz1803M936eK9371O542M1432N98dKzz1202hzz8275bhz2dh95h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Subject: RE: [PATCH V2] tty/serial: add support for Xilinx PS UART
Date: Fri, 22 Apr 2011 07:40:06 -0600
In-Reply-To: <1303464033.26896.11.camel@Joe-Laptop>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH V2] tty/serial: add support for Xilinx PS UART
Thread-Index: AcwAzorXrPTiDbf3R6CDIoyPokiHPQAI8CBw
References: <90e49570-bc82-41a9-ac79-2f5007e93a2a@VA3EHSMHS018.ehs.local> <4DB14626.8090002@petalogix.com> <1303464033.26896.11.camel@Joe-Laptop>
From: John Linn <John.Linn@xilinx.com>
To: Joe Perches <joe@perches.com>, <michal.simek@petalogix.com>
CC: <linux-kernel@vger.kernel.org>, <linux-serial@vger.kernel.org>,
        <alan@lxorguk.ukuu.org.uk>, <greg@kroah.com>,
        <grant.likely@secretlab.ca>
X-OriginalArrivalTime: 22 Apr 2011 13:40:07.0399 (UTC) FILETIME=[CAF43770:01CC00F2]
Message-ID: <15951ed5-383b-47ad-bbbd-47650f04735a@VA3EHSMHS026.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p3MDeNXN030037

> -----Original Message-----
> From: Joe Perches [mailto:joe@perches.com]
> Sent: Friday, April 22, 2011 3:21 AM
> To: michal.simek@petalogix.com
> Cc: John Linn; linux-kernel@vger.kernel.org; linux-
> serial@vger.kernel.org; alan@lxorguk.ukuu.org.uk; greg@kroah.com;
> grant.likely@secretlab.ca
> Subject: Re: [PATCH V2] tty/serial: add support for Xilinx PS UART
> 
> On Fri, 2011-04-22 at 11:11 +0200, Michal Simek wrote:
> > John Linn wrote:
> > > The Xilinx PS Uart is used on the new ARM based SoC. This
> > > UART is not compatible with others such that a seperate
> > > driver is required.
> []
> > > +++ b/drivers/tty/serial/xilinx_uartps.c
> []
> > > +		rc = uart_add_one_port(&xuartps_uart_driver, port);
> > > +		if (rc) {
> > > +			dev_err(&pdev->dev, "uart_add_one_port() failed; \
> > > +						err=%i\n", rc);
> 
> That's a whitespace error.
> Please don't be concerned about 80 column lines used for formatting.
> You could use something like this as well.

Thanks Joe.  I'm surprised checkpatch didn't catch that.  Easy enough
to fix on the next spin of the patch.

I thought checkpatch did complain if the lines were longer than 80, but
maybe there are some exceptions I didn't realize.  

Thanks for your time and input, learning more everyday :)
John

> 
> 			dev_err(&pdev->dev,
> 				"uart_add_one_port() failed; err=%d\n", rc);
> 
> 


This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
