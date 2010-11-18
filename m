Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932429Ab0KRQfJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 11:35:09 -0500
Received: from cantor.suse.de ([195.135.220.2]:53286 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932243Ab0KRQfH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 11:35:07 -0500
Date: Thu, 18 Nov 2010 08:33:21 -0800
From: Greg KH <gregkh@suse.de>
To: Timur Tabi <timur@freescale.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Scott Wood <scottwood@freescale.com>,
        Stuart Yoder <stuart.yoder@freescale.com>
Subject: Re: How do I choose an arbitrary minor number for my tty device?
Message-ID: <20101118163321.GA2723@suse.de>
References: <4CE44B1B.9040709@freescale.com>
 <20101117215147.GA26792@suse.de>
 <4CE452CD.3050001@freescale.com>
 <20101117221903.GA4066@suse.de>
 <4CE45A4E.70308@freescale.com>
 <20101118022434.GA9833@suse.de>
 <4CE546C5.8060401@freescale.com>
 <20101118153912.GA1443@suse.de>
 <4CE54E40.9040503@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CE54E40.9040503@freescale.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 10:03:12AM -0600, Timur Tabi wrote:
> Greg KH wrote:
> >> > 
> >> > I'm still not sure why you think I have a bus.  I don't see where the UART
> >> > drivers register a bus, and there's not a whole lot different between a byte
> >> > channel and a UART.
> 
> > But they are obviously two different things, right?
> 
> Well, sure.  A byte channel is just a software concept.  You can send data,
> receive data, and poll a byte channel.  You can't set the baud rate, or send
> break signals or even do flow control.  I debated making the driver act like a
> fake serial device, which probably would have been easier but not "correct".
> 
> Unfortunately, I seem to lack some fundamental understanding of tty drivers that
> is making my life difficult.  I've been reading all the documentation that I can
> get my hands on, as well as studying a lot of source code, but I still can't
> find any example to base *my* code on.  I just don't know if what I'm doing is
> right.
> 
> I still don't know how to connect the byte channel handle with the /dev entry.
> That's the question my original post asked, and I still don't have an answer to it.

Ok, I think I'm getting totally confused here.

If all you want is a tty driver, then just write a tty driver.  No need
for character device nodes or any of that other stuff.  Just assign
minor numbers to the device, create it, attach it to the tty core, and
away you go.

I think you are going to have to show code here to get any kind of a
better response out of me as I don't think we are understanding each
other here, sorry.

greg k-h
