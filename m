Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751481Ab2IXXjz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 19:39:55 -0400
Received: from shmail0.sohard.de ([212.114.139.117]:34463 "EHLO
	shmail0.sohard.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763Ab2IXXjy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 19:39:54 -0400
Date: Tue, 25 Sep 2012 01:39:50 +0200 (CEST)
From: Rene Buergel <rene.buergel@sohard.de>
To: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [Patch v4] ezusb: move ezusb.c from drivers/usb/serial to drivers/usb/misc
Message-ID: <09740048-b0e1-488b-8a84-53d86f3c39b2@shmail0>
In-Reply-To: <20120921164713.GA7788@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Originating-IP: [77.7.57.173]
X-Mailer: Zimbra 7.1.3_GA_3374 (ZimbraWebClient - FF3.0 (Win)/7.1.3_GA_3346)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ERROR: "ezusb_fx1_ihex_firmware_download"
> [drivers/usb/serial/whiteheat.ko] undefined!
> ERROR: "ezusb_fx1_ihex_firmware_download"
> [drivers/usb/serial/keyspan_pda.ko] undefined!
> ERROR: "ezusb_fx1_set_reset" [drivers/usb/serial/keyspan_pda.ko]
> undefined!
> ERROR: "ezusb_fx1_ihex_firmware_download"
> [drivers/usb/serial/keyspan.ko] undefined!
> 
> What I did was:
>   - build the kernel without this patch.
>   - apply the patch
>   - run make to build the kernel again.
> 
> Something isn't getting rebuilt properly, and this is going to hit
> lots of other kernel developers, so I can't take this as-is.
> 
> I've attached my .config file below, maybe something there can help
> with figuring it out?

thanks!

i managed to reproduce the error with your config.
I'm still trying to figure out why my config worked fine and how to fix this...

This might take me a while.


René Bürgel
