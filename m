Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087Ab2INGze (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 02:55:34 -0400
Received: from shmail0.sohard.de ([212.114.139.117]:53001 "EHLO
	shmail0.sohard.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512Ab2INGzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 02:55:32 -0400
Date: Fri, 14 Sep 2012 08:55:31 +0200 (CEST)
From: Rene Buergel <rene.buergel@sohard.de>
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/4]: ezusb: move ezusb.c from drivers/usb/serial to drivers/usb/misc
Message-ID: <98c1ecc0-4b6f-43a8-893a-b292f9b5a759@shmail0>
In-Reply-To: <20120914050328.GB21944@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [77.190.66.255]
X-Mailer: Zimbra 7.1.3_GA_3374 (ZimbraWebClient - FF3.0 (Win)/7.1.3_GA_3346)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Also, why move it?  Are there other modules that need to use it?

Fullquote from Aug, 24:
> > > > - Although i removed the dependency from ezusb to usb_serial,
> > > >   ezusb.c still resides in drivers/usb/serial.
> > > >   Can you give me a hint, where to put it instead?
> > > >   I would like to do that with an additional patch.
> > > 
> > > Why do you want to move it?
> > 
> > because is has nothing to do with any serial stuff anymore...
> 
> Fair enough, how about drivers/usb/misc/ instead?
> 
> greg k-h
> 
