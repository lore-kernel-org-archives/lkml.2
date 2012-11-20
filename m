Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537Ab2KTQOb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 11:14:31 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:41062 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752621Ab2KTQO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 11:14:28 -0500
Date: Tue, 20 Nov 2012 11:14:27 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Udo van den Heuvel <udovdh@xs4all.nl>
cc: linux-usb@vger.kernel.org, Jan Ceuleers <jan.ceuleers@computer.org>,
        Clemens Ladisch <clemens@ladisch.de>,
        Simon Jones <sijones2010@gmail.com>, <linux-kernel@vger.kernel.org>
Subject: Re: 3.4.4: disabling irq
In-Reply-To: <50AB96A0.80009@xs4all.nl>
Message-ID: <Pine.LNX.4.44L0.1211201112360.1692-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Nov 2012, Udo van den Heuvel wrote:

> > Secondly, try building a kernel with the patch below and 
> > CONFIG_USB_DEBUG enabled.  Let's see what the dmesg log says when the 
> > problem occurs.
> 
> I just booted into 3.6.7 with the patch:
> 
> # dmesg|sort|uniq
> ohci_hcd 0000:00:12.0: IRQ: 24 8000005a
> ohci_hcd 0000:00:14.5: IRQ: 24 8000005a
> #
> 
> So what does this mean?
> I did not get the `disabling irq` yet.

It means your system was working normally.  Which you already knew, 
because the IRQ didn't get disabled.

Alan Stern

