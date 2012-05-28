Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952Ab2E1OUL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 10:20:11 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:63848 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754655Ab2E1OUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 10:20:03 -0400
MIME-Version: 1.0
In-Reply-To: <20120528135433.GC7392@kroah.com>
References: <20120426001529.GA14006@kroah.com>
	<CALF0-+UeGxjML71sWGr8A-mEwBQRyFd6fcXa2Q0VZ3dxgWPwZg@mail.gmail.com>
	<20120528135433.GC7392@kroah.com>
Date: Mon, 28 May 2012 11:20:02 -0300
Message-ID: <CALF0-+WHP-w8LYQsBDjDjyZisL1m4FmB3DS0kGRK4UxAyr79vA@mail.gmail.com>
Subject: Re: [RFC PATCH] USB: remove CONFIG_USB_DEVICEFS
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kay Sievers <kay@vrfy.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, May 28, 2012 at 10:54 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Mon, May 28, 2012 at 09:37:44AM -0300, Ezequiel Garcia wrote:
>> Hi Greg,
>>
>> On Wed, Apr 25, 2012 at 9:15 PM, Greg Kroah-Hartman
>> <gregkh@linuxfoundation.org> wrote:
>> > This option has been deprecated for many years now, and no userspace
>> > tools use it anymore, so it should be safe to finally remove it.
>> >
>>
>> Does this mean usbview will be completely deprecated?
>> Do you think is it possible to write an update for it?
>
> It works just fine if you point usbview at
> /sys/kernel/debug/usb/devices, right?
>

Yes, it does.

Thanks,
Ezequiel.
