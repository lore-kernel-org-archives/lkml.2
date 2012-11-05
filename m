Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063Ab2KEMZ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 07:25:56 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:38665 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686Ab2KEMZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 07:25:54 -0500
Message-ID: <5097B04B.4070106@gmail.com>
Date: Mon, 05 Nov 2012 13:25:47 +0100
From: Stefan Koch <stefan.koch10@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111120 Icedove/3.1.16
MIME-Version: 1.0
To: richard -rw- weinberger <richard.weinberger@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: IMX257 framebuffer problem
References: <509430C3.9090401@gmail.com>	<509792FB.1080604@gmail.com> <CAFLxGvx-Q3Ye4obNnVbEbEpG8YwecKxEXU0wg11Q1kDrOA1X9w@mail.gmail.com>
In-Reply-To: <CAFLxGvx-Q3Ye4obNnVbEbEpG8YwecKxEXU0wg11Q1kDrOA1X9w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'll try it...

Could be this a problem?:
"imx-sdma imx35-sdma: firmware not found" appears when booting the 
kernel without enabled fb.

In FB enabled kernel's the last debugable function is 
imx_add_platform_device_dmamask()

Both have "dma" in the string...

But for loading a firmware from filesystem, the kernel crashes to early, 
I think.

If you subscribed to linux-fbdev mailing list, can you check If my 
message is come in there?
Because marc.info archives does not show my messages on linux-fbdev, but 
all from other people after my message.
I have send the message more times.

Thanks


Am 05.11.2012 11:43, schrieb richard -rw- weinberger:
> On Mon, Nov 5, 2012 at 11:20 AM, Stefan Koch<stefan.koch10@gmail.com>  wrote:
>>> What could be the problem?
> Find out what exactly is happening after calling add_imx_fb().
> Call it a bit later so that you can see everything on the UART.
> You can hack the call into init/main.c or something else...
>

