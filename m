Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766Ab2ISSXM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 14:23:12 -0400
Received: from shmail0.sohard.de ([212.114.139.117]:34100 "EHLO
	shmail0.sohard.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299Ab2ISSXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 14:23:09 -0400
Date: Wed, 19 Sep 2012 20:23:07 +0200 (CEST)
From: Rene Buergel <rene.buergel@sohard.de>
To: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: USB: ezusb: move ezusb.c from drivers/usb/serial to drivers/usb/misc
Message-ID: <23459b4f-b303-4b3b-a0ef-152064209bb3@shmail0>
In-Reply-To: <20120918163732.GA28387@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [77.7.73.0]
X-Mailer: Zimbra 7.1.3_GA_3374 (ZimbraWebClient - FF3.0 (Win)/7.1.3_GA_3346)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I get the following build errors with
> this patch applied:
> 
> ERROR: "ezusb_fx1_ihex_firmware_download"
> [drivers/usb/serial/whiteheat.ko] undefined!
> ERROR: "ezusb_fx1_ihex_firmware_download"
> [drivers/usb/serial/keyspan_pda.ko] undefined!
> ERROR: "ezusb_fx1_set_reset" [drivers/usb/serial/keyspan_pda.ko]
> undefined!
> ERROR: "ezusb_fx1_ihex_firmware_download"
> [drivers/usb/serial/keyspan.ko] undefined!
> 

I unfortunately can't reproduce these errors, neither using bool nor tristate
for the setting in Kconfig. I did a clean build.
Can you provide more information on when/how they occur? Can you send a .config?

> Which is odd, as I thought those functions were exported.
> 
> So something is wrong here with this patch, I've applied the first 2
thanks for that

> care to redo this one so it works properly?
sure!
