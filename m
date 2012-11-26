Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745Ab2KZQLL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 11:11:11 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:43846 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754544Ab2KZQLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 11:11:09 -0500
Date: Mon, 26 Nov 2012 11:11:08 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: naveen yadav <yad.naveen@gmail.com>
cc: linux-kernel@vger.kernel.org, <linux-usb@vger.kernel.org>,
        <marcel@holtmann.org>, <padovan@profusion.mobi>,
        <linux-bluetooth@vger.kernel.org>,
        vivek bhagat <vivek.bhagat89@gmail.com>
Subject: Re: USB 2.0: No giveback comes for one submitted URB
In-Reply-To: <CAJ8eaTxC1EiTwn-KSjW32WKi-4LsVt0YPrTn+xjtYEA9h0Dgdg@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1211261109360.2168-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Nov 2012, naveen yadav wrote:

> Dear Alan,
> 
> Thanks for your reply ,
> 
> We check on 3.2.34 and 3.6.7 on X86 host machine. and result is same
> without connecting Bluetooth device.
> I am attaching log

Yes, very good.  But you still have to do what I mentioned in my
earlier email:

> On Thu, Nov 22, 2012 at 9:08 PM, Alan Stern <stern@rowland.harvard.edu> wrote:

> > Now you need to find out what other code has changed urb->use_count and
> > fix it.

Alan Stern

