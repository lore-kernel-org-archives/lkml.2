Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753645Ab1JLQ7E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 12:59:04 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:62557 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356Ab1JLQ7D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 12:59:03 -0400
MIME-Version: 1.0
In-Reply-To: <20111012141724.GA17414@suse.de>
References: <CA+O4pCKMiLK3Z94j1NjVA3Zu-32X=tC-6eZnwGZCQXUTbhiEwA@mail.gmail.com>
	<20111012141724.GA17414@suse.de>
Date: Wed, 12 Oct 2011 18:59:01 +0200
Message-ID: <CA+O4pCJ3rte3eHUy44JWsYo5BqVzRNXojLYLo6uOd8cRQGs=LQ@mail.gmail.com>
Subject: Re: [Patch] Increase USBFS Bulk Transfer size
From: Markus Rechberger <mrechberger@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        USB list <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 12, 2011 at 4:17 PM, Greg KH <gregkh@suse.de> wrote:
> On Wed, Oct 12, 2011 at 02:36:59PM +0200, Markus Rechberger wrote:
>> We have 2 products which can perform better with increased Bulk transfers
>
> I don't believe you :)
>
> As stated before, this patch is not acceptable.  Please work to figure
> out the real reason for your device problems here, this is not the
> correct solution at all.
>

OK no device support for linux then. Windows and MacOSX are fine.

Let me know when you are in Berlin I can give you the device and you
can figure it out by yourself
I'm done with talking about those issues now since I spent too much
time on figuring out
how to get this device work. I guess after 3 years successfully
working with USBFS you can assume that I have
some experience with using this API. If Linux cannot offer support for
this not my fault.

Great achievement!

Markus
> sorry,
>
> greg k-h
>
