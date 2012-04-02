Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554Ab2DBRDP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 13:03:15 -0400
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:46635 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752961Ab2DBRDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 13:03:11 -0400
MIME-Version: 1.0
In-Reply-To: <20120402143448.GD922@valkosipuli.localdomain>
References: <1327574749-18552-1-git-send-email-balbi@ti.com>
	<20120402143448.GD922@valkosipuli.localdomain>
Date: Mon, 2 Apr 2012 22:33:10 +0530
Message-ID: <CAAe_U6+kqyn7mdujJKr-ysC+HyA0=pyO012H-FxYY6DSRjznJQ@mail.gmail.com>
Subject: Re: [PATCH] usb: musb: make modules behave better
From: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Felipe Balbi <balbi@ti.com>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        davinci-linux-open-source@linux.davincidsp.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Apr 2, 2012 at 8:04 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> Hi Felipe,
>
> On Thu, Jan 26, 2012 at 12:45:49PM +0200, Felipe Balbi wrote:
>> There's really no point in doing all that
>> initcall trickery when we can safely let
>> udev handle module probing for us.
>>
>> Remove all of that trickery, by moving everybody
>> to module_init() and making proper use of
>> platform_device_register() rather than
>> platform_device_probe().
>>
>> Signed-off-by: Felipe Balbi <balbi@ti.com>
>> ---
>>
>> Because this falls into the "has never worked before" category
>> I will be sending this only on the next merge window. This
>> also gives people enough time to complain about any mistakes
>> on the patch.
>
> This patch looks correct and right to me, but it breaks musb when it's
> compiled into the kernel, at least on the Nokia N950. I haven't yet figured
> out exactly why, though.

Is it an abort?
You can use the patch which I've sent to the list last week for fixing it.
http://www.spinics.net/lists/linux-usb/msg60603.html.

Thanks
Kishon
