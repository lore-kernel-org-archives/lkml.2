Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854Ab2CLFVw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 01:21:52 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:33506 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556Ab2CLFVo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 01:21:44 -0400
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: linux-usb@vger.kernel.org,
        =?utf-8?Q?Lothar_Wa=C3=9Fmann?= <LW@karo-electronics.de>
Cc: "Felipe Balbi" <balbi@ti.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb gadget: fix a section mismatch when compiling g_ffs
 with CONFIG_USB_FUNCTIONFS_ETH
References: <1331472670-28589-1-git-send-email-LW@KARO-electronics.de>
 <1331474926-9237-1-git-send-email-LW@KARO-electronics.de>
Date: Mon, 12 Mar 2012 06:21:41 +0100
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.wa1k6fem3l0zgt@mpn-glaptop>
In-Reply-To: <1331474926-9237-1-git-send-email-LW@KARO-electronics.de>
User-Agent: Opera Mail/11.61 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Mar 2012 15:08:46 +0100, Lothar Waßmann <LW@karo-electronics.de> wrote:
> Hi,
>
> please ignore the previous message. I sent the patch out too early.
> Here is a revised version.
>
>  commit 28824b18ac4705e876a282a15ea0de8fc957551f:
>  |Author: Michal Nazarewicz <m.nazarewicz@samsung.com>
>  |Date:   Wed May 5 12:53:13 2010 +0200
>  |
>  |    USB: gadget: __init and __exit tags removed
>  |
>  |    __init, __initdata and __exit tags have have been removed from
>  |    various files to make it possible for gadgets that do not use
>  |    the __init/__exit tags to use those.
>  obviously missed (at least) this case leading to a section mismatch in
>  g_ffs.c when compiling with CONFIG_USB_FUNCTIONFS_ETH enabled.
>
> Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>

Acked-by: Michal Nazarewicz <mina86@mina86.com>

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--
