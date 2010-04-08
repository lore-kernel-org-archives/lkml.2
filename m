Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933190Ab0DHSSL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 14:18:11 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:58298 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933118Ab0DHSRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 14:17:42 -0400
Date: Thu, 8 Apr 2010 14:17:41 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Pedro Ribeiro <pedrib@gmail.com>
cc: Daniel Mack <daniel@caiaq.de>, Robert Hancock <hancockrwd@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: USB transfer_buffer allocations on 64bit systems
In-Reply-To: <h2m74fd948d1004081017p6fe8652cpee34d79edf65508b@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1004081416560.1720-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Apr 2010, Pedro Ribeiro wrote:

> > Pedro, in the hope of tracking down the problem, can you apply this
> > patch and see what output it produces in the system log when the
> > "interference" happens?  (Warning: It will produce quite a lot of
> > output whenever you send data to the audio device -- between 500 and
> > 1000 lines per second.)

> I'll do it tonight and send you the results tomorrow morning. Do you
> want CONFIG_USB_DEBUG enabled or disabled?

It doesn't matter.

Alan Stern

