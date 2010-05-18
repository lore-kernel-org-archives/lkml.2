Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757863Ab0EROpj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 10:45:39 -0400
Received: from kroah.org ([198.145.64.141]:51430 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757737Ab0EROpg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 10:45:36 -0400
Date: Tue, 18 May 2010 07:43:58 -0700
From: Greg KH <greg@kroah.com>
To: CaT <cat@zip.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, bzolnier@gmail.com,
       stable@kernel.org, ben@decadent.org.uk,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.34 (rt2860 regression)
Message-ID: <20100518144358.GA24803@kroah.com>
References: <alpine.LFD.2.00.1005161430100.4195@i5.linux-foundation.org>
 <20100518114426.GY2657@zip.com.au>
 <20100518125539.GA23181@kroah.com>
 <20100518131706.GZ2657@zip.com.au>
 <20100518133336.GA23591@kroah.com>
 <20100518141315.GA2657@zip.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100518141315.GA2657@zip.com.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 19, 2010 at 12:13:15AM +1000, CaT wrote:
> On Tue, May 18, 2010 at 06:33:36AM -0700, Greg KH wrote:
> > Just update the linux-firmware package and all will be working again.
> > We've been moving the firmware out of the staging drivers for a while
> > now, as they don't belong in the kernel tree.
> 
> Curses. Ok. Is there any chance of being able to include these in the
> vmlinuz file (for the sake of tidyness) or are, after 12 years or so,
> my monolithic days over?

For hardware with firmware packages like this, yes, sorry, it is.
Welcome to the new century :)

greg k-h
