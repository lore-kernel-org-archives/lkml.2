Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110Ab2HTIxC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 04:53:02 -0400
Received: from shmail0.sohard.de ([212.114.139.117]:48414 "EHLO
	shmail0.sohard.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331Ab2HTIw7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 04:52:59 -0400
Date: Mon, 20 Aug 2012 10:52:56 +0200 (CEST)
From: Rene Buergel <rene.buergel@sohard.de>
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3]: ezusb cleanup, FX2 support, firmware downloading support
Message-ID: <7ea0bc18-451f-4025-885b-5071b82e8769@shmail0>
In-Reply-To: <20120815222055.GA22907@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Originating-IP: [194.138.39.52]
X-Mailer: Zimbra 7.1.3_GA_3374 (ZimbraWebClient - IE8 (Win)/7.1.3_GA_3346)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Ursprüngliche Mail -----
> On Fri, Aug 03, 2012 at 05:06:27PM +0200, René Bürgel wrote:
> > Hello,
> > 
> > this is a patches-series for controllers using the ezusb-functions.
> > 
> > ezusb:  remove dependency to usb_serial interface
> > euzsb: add support for Cypress FX2LP
> > ezusb: add functions for firmware download
> 
> Nice series, but your patches are white-space damaged, and I can't
> apply
> them at all.
> 
> Also, your third patch has the wrong Subject: line 
> 
> Care to resend them in a format that I can apply them in?
> 
> thanks,
> 
> greg k-h
> 

Thanks for reviewing it. 

I will check my email-settings and resend the patches.

I'm sorry about the wrong Subject line, this will be corrected when resending.

I got some further questions: 
- Although i removed the dependency from ezusb to usb_serial,
  ezusb.c still resides in drivers/usb/serial.
  Can you give me a hint, where to put it instead?
  I would like to do that with an additional patch.
- is it fine to base the soon-to-be-resent patches on 3.6-rc2?


René Bürgel
