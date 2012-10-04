Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749Ab2JDHZg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 03:25:36 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:60996 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307Ab2JDHZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 03:25:32 -0400
Date: Thu, 4 Oct 2012 00:25:28 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Przemo Firszt <przemo@firszt.eu>
Cc: rob@landley.net, pinglinux@gmail.com, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH] USB: input: wacom_sys.c: format OLED image in kernel
Message-ID: <20121004072528.GD14217@core.coreip.homeip.net>
References: <1347219438-2598-1-git-send-email-przemo@firszt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347219438-2598-1-git-send-email-przemo@firszt.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Przemo,

On Sun, Sep 09, 2012 at 03:37:18PM -0400, Przemo Firszt wrote:
> This patch adds a new way of handling Wacom Intuos4 family OLEDs.
> Previously the images had to be 'scrambled' by userland application. Now
> the 'scrambling' is done in the kernel module, so user space can send
> simple 64x32 pixels 4-bit grayscale (2 pixels per byte) 0,0 in top left corner
> images straight to a wacom OLED sysfs entry. An example:
> 
> dd bs=1024 if=image_file \
> of=/sys/bus/usb/drivers/wacom/[DevNo]/wacom_led/button[No]_formattedimg \
> count=1
> 
> This patch greatly simplifies user space preparation of the image.
> The raw image sysfs enties are still present to avoid breaking API.

I do not not believe that we should add code to the kernel for tasks that
can be just as easily performed in userspace.

Thanks!

-- 
Dmitry
