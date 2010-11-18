Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759926Ab0KRQwD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 11:52:03 -0500
Received: from cantor.suse.de ([195.135.220.2]:53922 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759898Ab0KRQwB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 11:52:01 -0500
Date: Thu, 18 Nov 2010 08:51:36 -0800
From: Greg KH <gregkh@suse.de>
To: Timur Tabi <timur@freescale.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Scott Wood <scottwood@freescale.com>,
        Stuart Yoder <stuart.yoder@freescale.com>
Subject: Re: How do I choose an arbitrary minor number for my tty device?
Message-ID: <20101118165136.GA3103@suse.de>
References: <20101117215147.GA26792@suse.de>
 <4CE452CD.3050001@freescale.com>
 <20101117221903.GA4066@suse.de>
 <4CE45A4E.70308@freescale.com>
 <20101118022434.GA9833@suse.de>
 <4CE546C5.8060401@freescale.com>
 <20101118153912.GA1443@suse.de>
 <4CE54E40.9040503@freescale.com>
 <20101118163321.GA2723@suse.de>
 <4CE5562B.8080604@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CE5562B.8080604@freescale.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 10:36:59AM -0600, Timur Tabi wrote:
> Greg KH wrote:
> > If all you want is a tty driver, then just write a tty driver.  No need
> > for character device nodes or any of that other stuff.  Just assign
> > minor numbers to the device, create it, attach it to the tty core, and
> > away you go.
> 
> What I would like to do is have some control over the name or minor number of
> the /dev entry.

Why?  Again, it doesn't matter, and no other tty driver does it.

Actually you do have control over it, if you really want it, but again,
don't do that :)

> > I think you are going to have to show code here to get any kind of a
> > better response out of me as I don't think we are understanding each
> > other here, sorry.
> 
> I'll have to email it to you directly, since it's not authorized for public
> distribution just quite yet.

Sorry, I can't do code review, or accept code that is not allowed to be
sent to the public, as, surprise, I'm public :)

So you just sent me an illegal file, great, should I expect to hear from
your lawyers now?

{sigh}

I deal enough with lawyers as it is, please don't do this...

greg k-h
