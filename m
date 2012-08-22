Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756702Ab2HVH0q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 03:26:46 -0400
Received: from shmail0.sohard.de ([212.114.139.117]:34295 "EHLO
	shmail0.sohard.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754819Ab2HVH0o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 03:26:44 -0400
Date: Wed, 22 Aug 2012 09:26:41 +0200 (CEST)
From: Rene Buergel <rene.buergel@sohard.de>
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3]: ezusb cleanup, FX2 support, firmware downloading support
Message-ID: <08c78af9-4c08-4fa6-82f1-8e9e0c0bc333@shmail0>
In-Reply-To: <20120820144937.GB27266@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Originating-IP: [77.190.105.16]
X-Mailer: Zimbra 7.1.3_GA_3374 (ZimbraWebClient - FF3.0 (Win)/7.1.3_GA_3346)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > - Although i removed the dependency from ezusb to usb_serial,
> >   ezusb.c still resides in drivers/usb/serial.
> >   Can you give me a hint, where to put it instead?
> >   I would like to do that with an additional patch.
> 
> Why do you want to move it?

because is has nothing to do with any serial stuff anymore...

> 
> > - is it fine to base the soon-to-be-resent patches on 3.6-rc2?
> 
> You should redo them against the linux-next tree, which has many more
> patches than 3.6-rc2.

ok, thanks!

> 
> greg k-h
> 

René Bürgel
