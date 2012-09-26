Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332Ab2IZWgT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 18:36:19 -0400
Received: from shmail0.sohard.de ([212.114.139.117]:50067 "EHLO
	shmail0.sohard.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954Ab2IZWgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 18:36:17 -0400
Date: Thu, 27 Sep 2012 00:36:14 +0200 (CEST)
From: Rene Buergel <rene.buergel@sohard.de>
To: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [Patch v5] ezusb: move ezusb.c from drivers/usb/serial to	drivers/usb/misc
Message-ID: <a5e25079-225b-4889-b57e-cdff4c7d68d9@shmail0>
In-Reply-To: <20120926212710.5775.qmail@stuge.se>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [77.190.122.127]
X-Mailer: Zimbra 7.1.3_GA_3374 (ZimbraWebClient - FF3.0 (Win)/7.1.3_GA_3346)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Also, does the code in fact support only FX2, neither older chips nor
> newer FX3?
It also does support the FX(1), but not FX3. At first sight, it looks like FX3 got another
register interface.


> If FX is also supported then perhaps still rename the option,
> although I think renaming is unrelated to the build problems.
>
> I think it makes sense to call the option after the "highest"
> supported chip.
That's what it is. ;)
I would be happy to re-rename this option to USB_EZUSB somewhere in the future,
but i think it is the best option to stick with this for at least one
major version to avoid build errors.

>
>
> //Peter
>
