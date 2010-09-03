Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277Ab0ICOAG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 10:00:06 -0400
Received: from kroah.org ([198.145.64.141]:38734 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347Ab0ICOAF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 10:00:05 -0400
Date: Fri, 3 Sep 2010 07:00:41 -0700
From: Greg KH <greg@kroah.com>
To: Prabhu Chawandi <prabhu.chavandi@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        kernelnewbies@nl.linux.org
Subject: Re: Crash on reducing the kernel mem.
Message-ID: <20100903140041.GA16223@kroah.com>
References: <AANLkTimSsj5eW1Vy3g7S0XCKRcZ0fZ0jQ6_9VpjVMYcj@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimSsj5eW1Vy3g7S0XCKRcZ0fZ0jQ6_9VpjVMYcj@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 03, 2010 at 12:04:09PM +0530, Prabhu Chawandi wrote:
> Hi all,
> 
>  I am using MIPS processor, with 256 MB RAM. currently I am using 128
> M for drivers and 128 M for Kernel. I tried to allocate more memory
> for Drivers,
> surprisingly I got crash when I reduced kernel memory to 110 M. My
> debugging took me to USB controller, which was not reset in
> bootloader.
> 
> I am not having any clue, why it didnt crash with 128 M ? How reducing
> memory  for kernel bringing it up ?

Perhaps your drivers really needed that much memory.  How are you
"splitting" memory up between drivers and the kernel when the drivers
and kernel all share the same memory areas?

good luck,

greg k-h
