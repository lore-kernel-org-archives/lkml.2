Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685Ab2KRDkX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 22:40:23 -0500
Received: from mail.kernel.org ([198.145.19.201]:33476 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752562Ab2KRDkW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 22:40:22 -0500
Date: Sat, 17 Nov 2012 19:41:17 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Thiago Farina <tfransosi@gmail.com>
Cc: linux list <linux-kernel@vger.kernel.org>, tom.leiming@gmail.com
Subject: Re: =?utf-8?Q?drivers=2Fusb=2Fusb-skeleton?=
 =?utf-8?B?LmM6MTE3OjM6IGVycm9yOiBsYWJlbCDigJhvdXRfZXJy?= =?utf-8?B?4oCZ?=
 used but not define
Message-ID: <20121118034117.GA2604@kroah.com>
References: <CACnwZYdSW5=MLBrOC_cD7b3AB_PcQeyjR=JPJnfPCzJapZbGEw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACnwZYdSW5=MLBrOC_cD7b3AB_PcQeyjR=JPJnfPCzJapZbGEw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 17, 2012 at 11:34:19PM -0200, Thiago Farina wrote:
> Hi,
> 
> When compiling this source file with the following command line I get
> this error:

What kernel version are you building?

> $ make drivers/usb/usb-skeleton.o
> drivers/usb/usb-skeleton.c: In function ‘skel_open’:
> drivers/usb/usb-skeleton.c:117:3: error: label ‘out_err’ used but not defined
> make[1]: *** [drivers/usb/usb-skeleton.o] Error 1
> make: *** [drivers/usb/usb-skeleton.o] Error 2
> 
> Is this intentional?

No :)

> If not, what would be the right fix?

Properly define out_err.

I thought this all got fixed up recently, what kernel version are you
looking at?

thanks,

greg k-h
