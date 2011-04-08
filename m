Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757336Ab1DHOhu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 10:37:50 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:40263 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752550Ab1DHOht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 10:37:49 -0400
Date: Fri, 8 Apr 2011 10:37:48 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oncaphillis <oncaphillis@snafu.de>
cc: Xiaofan Chen <xiaofanc@gmail.com>, <libusb-devel@lists.sourceforge.net>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [Libusb-devel] Kernel bug message and missing data on
 libusb_interrupt_transfer
In-Reply-To: <4D9ED03C.2000706@snafu.de>
Message-ID: <Pine.LNX.4.44L0.1104081034510.1992-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Apr 2011, Oncaphillis wrote:

> Just a short update,
> 
>   It doesn't seem to have anything to do with the libsub-1.0.x) version but
> with the --(enable|disable)-timerfd option of libusb configure. If 
> libusb was
> configured with --disable-timerfd, which was the case for our 1.0.6 libusb
> I get the kernel bug message in in slub.c module and eventually a
> kernel freeze. This holds true for libusb-1.0.8 and kernel 2.6.38.2

Can you post an example of the bug message (together with an
explanation of what you did to cause it) to LKML?  Change the Subject:  
line to something highly visible, like "Kernel BUG in 2.6.38.2 slub.c".

Alan Stern

