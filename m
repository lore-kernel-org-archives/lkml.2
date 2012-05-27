Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751161Ab2E0Et3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 00:49:29 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:45433 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774Ab2E0Et2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 00:49:28 -0400
MIME-Version: 1.0
In-Reply-To: <CAHkwNTnVgGt6J9gb2gZSpYra1HHPibgj+W9X_rEHjAyDnDL+Jg@mail.gmail.com>
References: <CANc+2y41rDOrAijbgOAgWiTPzGeyMW+EXSxmu+zTv2ZqG=TxFA@mail.gmail.com>
	<20120525062120.GA4445@kroah.com>
	<CAHkwNTmpDTe-jOvR1t4tKo6uR-oEOMk2Sj2p_v6JsVtQCF2zEg@mail.gmail.com>
	<CANc+2y5WXX1n8Hugej-STfVra_Pjhjpb_OvT6Tf-K8=-hxaH=g@mail.gmail.com>
	<CAHkwNTnVgGt6J9gb2gZSpYra1HHPibgj+W9X_rEHjAyDnDL+Jg@mail.gmail.com>
Date: Sun, 27 May 2012 10:19:26 +0530
Message-ID: <CANc+2y6uTcQxjRTAfBGvBJBUNh-SEtM_0s+7DBrSr=yULws1OA@mail.gmail.com>
Subject: Re: Code flow from device connection to device node in /dev creation
From: prasannatsmkumar <prasannatsmkumar@gmail.com>
To: Anil Nair <anilcoll90@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anil,

If I open a device file (say a printer device) who determines the
correct driver and sends the call? How subsequent calls get processed
etc. Yes I know the init function will be called while the driver is
loaded (while running insmod driver.ko). How a open or write call
comes to the driver from user space? Who keeps track of the driver's
internal data (*dev) and sends that while calling methods in the
driver? I am more interested in things like that.

Thanks,
Prasanna Kumar

On Sun, May 27, 2012 at 7:37 AM, Anil Nair <anilcoll90@gmail.com> wrote:
> Hi Prasanna,
>
> On Fri, May 25, 2012 at 8:13 PM, prasannatsmkumar
> <prasannatsmkumar@gmail.com> wrote:
>> Thanks for your recommendation but I have went through the USB 2.0
>> specification and also had a chance to glance Linux USB Stack Design
>> Book. I am interested in software side - how things are going in
>> Linux. Upon connecting a mass storage device or USB keyboard is
>> connected how things works - the flow and the stack. Including the
>> user space tools that gets involved.
>
> Try compiling the linux kernel CONFIG_USB_DEBUG enabled. You can learn
> a lot by observing the kernel log, to view kernel log type dmesg. Try
> using usbmon Documentation can be found in
> Documentation/usb/usbmon.txt, i hope you have tried that.
>           Typically a driver starts from the probe function checks if
> the device is listed in its table "usb_device_id", try working from
> the probe function. A good way to start is the usb-skeleton.c present
> in linux kernel source "drivers/usb/usb-skeleton.c".
>            Also working of a kernel module differ the life cycle of
> the kernel module start from _init function when it is called or
> inserted to kernel using "insmod" of "modprobe".
>            And make sure you use reply-to-all when in the mailing
> list. :).  So, that others can help you too.
>
>
>
> --
> Regards,
> Anil Nair
