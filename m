Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774Ab1JMUHx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 16:07:53 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:59470 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754606Ab1JMUHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 16:07:52 -0400
Date: Thu, 13 Oct 2011 16:07:51 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Markus Rechberger <mrechberger@gmail.com>
cc: Chris Friesen <chris.friesen@genband.com>, Greg KH <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Patch] Increase USBFS Bulk Transfer size
In-Reply-To: <CA+O4pCL2NmTgW2vDU=jdhyy1_PpuP3g9SVup=iwEOVGoGzHmUA@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1110131606030.2026-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Oct 2011, Markus Rechberger wrote:

> fair enough I have 2 devices which don't work properly with bulk.
> Device A works by adjusting a hardware register
> Device B is documented in this thread.
> 
> Device A causes corruptions when the hardwareregister is set to a
> buffersize > 16k.
> There is certainly something on the physical usb layer which is unknown to the
> (software) USB experts here.
> The logfiles in the previous email shows up enough and is clear enough.

When you ran the test using the 12288/11776 sizes, did you change the 
hardware register buffersize value?  Or did you leave it set to the 
same 24064 as in the other test?

Alan Stern

