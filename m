Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755707Ab0DITeM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 15:34:12 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:60928 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754327Ab0DITeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 15:34:07 -0400
Date: Fri, 9 Apr 2010 15:34:06 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Pedro Ribeiro <pedrib@gmail.com>
cc: Daniel Mack <daniel@caiaq.de>, Robert Hancock <hancockrwd@gmail.com>,
       <linux-kernel@vger.kernel.org>, <akpm@linux-foundation.org>,
       Greg KH <gregkh@suse.de>, <alsa-devel@alsa-project.org>,
       <linux-usb@vger.kernel.org>
Subject: Re: USB transfer_buffer allocations on 64bit systems
In-Reply-To: <w2r74fd948d1004091119j9f33d8a6kc1824d9243abf38b@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1004091529240.1852-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Apr 2010, Pedro Ribeiro wrote:

> > The DMA pointers do indeed look sane. I wanted to take a deeper look at
> > this and set up a 64bit system today. However, I fail to see the problem
> > here. Pedro, how much RAM does your machine have installed?

> It has 4 GB.

That means DMA mapping cannot be the cause of the problem.  :-(

Alan Stern

