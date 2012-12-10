Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751850Ab2LJL37 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 06:29:59 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:59867 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209Ab2LJL36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 06:29:58 -0500
MIME-Version: 1.0
In-Reply-To: <20226716.3fCgHS08dt@al>
References: <CADhePA2UTjvTmJOVnW_gNXmQ_T=Rk28HAf2pHqKj4akyp7+V9A@mail.gmail.com>
	<20226716.3fCgHS08dt@al>
Date: Mon, 10 Dec 2012 12:22:58 +0100
Message-ID: <CADhePA1HdiVxLdBgPqQe=89FojrZ14Aw0OjnvkubSkEetDG8_g@mail.gmail.com>
Subject: Re: [3.7-rc8 regression] Buffer I/O error on device sda during boot
 (attempt to access beyond end of device)
From: M Z <magez.magez@gmail.com>
To: Lekensteyn <lekensteyn@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2012 at 12:06 PM, Lekensteyn <lekensteyn@gmail.com> wrote:
> On Monday 10 December 2012 11:42:22 M Z wrote:
>> booting vanilla  3.7-rc8 kernel on Acer Aspire 1810TZ yields these
>> errors (I was using 3.6.9-1 and 3.5.5-1 from Debian experimental
>> before without these errors)
>>
>>  [    9.265058] attempt to access beyond end of device
> <snip>
>>  [    9.265389] Buffer I/O error on device sda1, logical block 121047812
>>
>>
>> Any idea before I hit the bisect route? (should I worry about these errors?
>> )
>
> This error immediately showed up when testing 3.7-rc8 and is discussed/patched
> already on https://lkml.org/lkml/2012/12/3/497.
>
> To cite from https://lkml.org/lkml/2012/12/3/510:
>> Anyway, to clarify: the printk's are harmless, since the IO past the
>> end of the device is just error'ed out, and always has been.  Which is
>> why I was considering just removing them.
>
> Regards,
> Peter


Thanks for the info and sorry for the noise. *note to self - do not
google while asleep*


Regards

Matej
