Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975Ab2GWOrF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 10:47:05 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:38346 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753660Ab2GWOrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 10:47:04 -0400
Date: Mon, 23 Jul 2012 10:47:02 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Sarbojit Ganguly <unixman.linuxboy@gmail.com>
cc: Daniel Mack <zonque@gmail.com>, <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Takashi Iwai <tiwai@suse.de>
Subject: Re: Kernel Oops while disconnecting USB peripheral (always)
In-Reply-To: <CAP2rAF-ZappKmznEVjd=kQgRx__oVZ3vSE53rWDHVJf6VwMVTA@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1207231044380.1633-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jul 2012, Sarbojit Ganguly wrote:

> Hello Daniel,
> 
> That is why I provided two stacks,
> 
> 1st one is when I tried to remove the USB hub (which connects a webcam
> + microphone)
> 2nd one is when I tried to remove an USB powered external HDD.
> 
> Just to make sure whether the problem is with USB sound or the USB subsystem.

Do you stop all the programs that are using the USB devices before 
unplugging the hub?  Do you unmount the USB HDD first?

The first crash shows a problem in the snd-usb-audio driver.

The second crash shows a problem in the VFS layer or in ext3, not in 
the USB stack.

Alan Stern

