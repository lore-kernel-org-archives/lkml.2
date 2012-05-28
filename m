Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632Ab2E1Nyo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 09:54:44 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34939 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754580Ab2E1Nym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 09:54:42 -0400
Date: Mon, 28 May 2012 22:54:33 +0900
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kay Sievers <kay@vrfy.org>
Subject: Re: [RFC PATCH] USB: remove CONFIG_USB_DEVICEFS
Message-ID: <20120528135433.GC7392@kroah.com>
References: <20120426001529.GA14006@kroah.com>
 <CALF0-+UeGxjML71sWGr8A-mEwBQRyFd6fcXa2Q0VZ3dxgWPwZg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALF0-+UeGxjML71sWGr8A-mEwBQRyFd6fcXa2Q0VZ3dxgWPwZg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 28, 2012 at 09:37:44AM -0300, Ezequiel Garcia wrote:
> Hi Greg,
> 
> On Wed, Apr 25, 2012 at 9:15 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > This option has been deprecated for many years now, and no userspace
> > tools use it anymore, so it should be safe to finally remove it.
> >
> 
> Does this mean usbview will be completely deprecated?
> Do you think is it possible to write an update for it?

It works just fine if you point usbview at
/sys/kernel/debug/usb/devices, right?

> It was a little more helpful for me than lsusb. (Is it just me?)

I think so, I have not gotten any comments on that program in a very
long time :)

thanks,

greg k-h
