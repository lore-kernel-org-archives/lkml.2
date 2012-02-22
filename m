Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948Ab2BVQh5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 11:37:57 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:59760 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973Ab2BVQh4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 11:37:56 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of josh.coombs@gmail.com designates 10.50.6.138 as permitted sender) smtp.mail=josh.coombs@gmail.com; dkim=pass header.i=josh.coombs@gmail.com
MIME-Version: 1.0
In-Reply-To: <CAMW5UfYGU+K0tet+z8g+fYS54jba57gaWW_C7r3VY9JcrDryRQ@mail.gmail.com>
References: <CAMW5UfYGU+K0tet+z8g+fYS54jba57gaWW_C7r3VY9JcrDryRQ@mail.gmail.com>
Date: Wed, 22 Feb 2012 11:37:55 -0500
Message-ID: <CAMW5UfYu+D8LypyRX7RqZ8dwf5t4yPhoO-906maGjVUqS8TGXg@mail.gmail.com>
Subject: Re: [PATCH] drivers/usb/misc/sisusbvga/sisusb.c Add support for
 Triton See 2 Xtreme
From: Josh Coombs <josh.coombs@gmail.com>
To: thomas@winischhofer.net
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I can confirm this applies cleanly to 3.3-rc4 on x86_64 now.

Joshua Coombs

On Sun, Jan 22, 2012 at 1:15 PM, Josh Coombs <josh.coombs@gmail.com> wrote:
> Hello Thomas,
>
> I've been playing with a Triton See 2 Xtreme SiS based USB VGA adapter
> and had decent luck with it under your driver after adding it's device
> ID.
>
> --- drivers/usb/misc/sisusbvga/sisusb.c.orig    2012-01-22 13:01:07.000000000 -0500
> +++ drivers/usb/misc/sisusbvga/sisusb.c 2012-01-22 13:01:26.000000000 -0500
> @@ -3247,6 +3247,7 @@ static const struct usb_device_id sisusb
>        { USB_DEVICE(0x0711, 0x0903) },
>        { USB_DEVICE(0x0711, 0x0918) },
>        { USB_DEVICE(0x0711, 0x0920) },
> +        { USB_DEVICE(0x0711, 0x0950) },
>        { USB_DEVICE(0x182d, 0x021c) },
>        { USB_DEVICE(0x182d, 0x0269) },
>        { }
>
> I've been primarily using it on an ARMv5 system, and will try to test
> on x86 soon.  I've used the patch on both 3.1-release and 3.2-release.
>  I just verified 3.3-RC1 hasn't had any changes to the sisusb driver
> and will be building a test kernel this afternoon.  Given it's just a
> one line tweak, is this patch sufficient to go upstream, or would you
> like some additional info from my setup first?
>
> Signed-off-by: Joshua Coombs <josh.coombs@gmail.com>
