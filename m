Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751107Ab0DJMtS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 08:49:18 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:36210 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838Ab0DJMtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 08:49:17 -0400
Date: Sat, 10 Apr 2010 14:49:12 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Pedro Ribeiro <pedrib@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Robert Hancock <hancockrwd@gmail.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Greg KH <gregkh@suse.de>,
       alsa-devel@alsa-project.org, linux-usb@vger.kernel.org
Subject: Re: USB transfer_buffer allocations on 64bit systems
Message-ID: <20100410124912.GP30801@buzzloop.caiaq.de>
References: <m2n74fd948d1004081613n90408827s7c51ef572848fb1d@mail.gmail.com>
 <Pine.LNX.4.44L0.1004091155570.1852-100000@iolanthe.rowland.org>
 <20100409180942.GK30801@buzzloop.caiaq.de>
 <w2r74fd948d1004091119j9f33d8a6kc1824d9243abf38b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <w2r74fd948d1004091119j9f33d8a6kc1824d9243abf38b@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 09, 2010 at 07:19:22PM +0100, Pedro Ribeiro wrote:
> On 9 April 2010 19:09, Daniel Mack <daniel@caiaq.de> wrote:
> > On Fri, Apr 09, 2010 at 12:01:27PM -0400, Alan Stern wrote:
> >> I don't see anything suspicious.  The transfer_buffer addresses repeat
> >> every 32 URBs, and the DMA addresses cycle almost entirely uniformly
> >> from 0x20000000 to 0x23ffffff in units of 0x2000 (there are a few gaps
> >> where the interval is a little bigger).
> >
> > The DMA pointers do indeed look sane. I wanted to take a deeper look at
> > this and set up a 64bit system today. However, I fail to see the problem
> > here. Pedro, how much RAM does your machine have installed?
> >
> > Daniel
> >
> >
> 
> It has 4 GB.

Upgraded my machine now to 4GB, but I still can't reproduce this bug.
Pedro, can you send your config, please?

Daniel
