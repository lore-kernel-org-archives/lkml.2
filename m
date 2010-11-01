Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757546Ab0KAMbi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 08:31:38 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:57593 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755916Ab0KAMbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 08:31:36 -0400
Message-ID: <4CCEB2BB.4020302@ru.mvista.com>
Date: Mon, 01 Nov 2010 15:29:47 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>
CC: Greg KH <gregkh@suse.de>, matthieu.castet@parrot.com,
        stern@rowland.harvard.edu, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, Nguyen Dinh-R00091 <R00091@freescale.com>
Subject: Re: [PATCH] USB: ehci/mxc: compile fix
References: <20101028181519.GD2573@kroah.com> <1288337869-378-1-git-send-email-u.kleine-koenig@pengutronix.de>
In-Reply-To: <1288337869-378-1-git-send-email-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 29-10-2010 11:37, Uwe Kleine-König wrote:

> 65fd42724aee31018b0bb53f4cb04971423be664  broke the build using

    Linus has asked people to also specify the commit short description in 
parens after SHA1.

> ARM's mx51_defconfig:

>   	  CC      drivers/usb/host/ehci-hcd.o
>   	In file included from drivers/usb/host/ehci-hcd.c:1166:
>   	drivers/usb/host/ehci-mxc.c: In function 'ehci_mxc_drv_probe':
>   	drivers/usb/host/ehci-mxc.c:192: error: 'ehci' undeclared (first use in this function)
>   	drivers/usb/host/ehci-mxc.c:192: error: (Each undeclared identifier is reported only once
>   	drivers/usb/host/ehci-mxc.c:192: error: for each function it appears in.)
>   	drivers/usb/host/ehci-mxc.c:117: warning: unused variable 'temp'
>   	make[3]: *** [drivers/usb/host/ehci-hcd.o] Error 1
>   	make[2]: *** [drivers/usb/host/ehci-hcd.o] Error 2
>   	make[1]: *** [sub-make] Error 2
>   	make: *** [all] Error 2

> Fix it together with the warnung about the unused variable.

> Tested-by: Dinh Nguyen<Dinh.Nguyen@freescale.com>
> Signed-off-by: Uwe Kleine-König<u.kleine-koenig@pengutronix.de>

WBR, Sergei
