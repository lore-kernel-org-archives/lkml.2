Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945Ab0KJNzZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 08:55:25 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:60686 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751701Ab0KJNzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 08:55:21 -0500
Date: Wed, 10 Nov 2010 14:54:58 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Ted Ts'o" <tytso@mit.edu>, david@lang.hm,
        Anca Emanuel <anca.emanuel@gmail.com>, Greg KH <greg@kroah.com>,
        Elvis Dowson <elvis.dowson@mac.com>,
        Janakiram Sistla <janakiram.sistla@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Forked android kernel development from linux kernel mainline
Message-ID: <20101110135458.GB1553@ucw.cz>
References: <01784A8B-36A0-4E8A-9729-23C2B19351F8@mac.com>
 <AANLkTi=UxhRdcDaoKaYVWhPkp_e-uLF4=zhXs7gutkgx@mail.gmail.com>
 <20101106181202.GA6927@kroah.com>
 <20101106192259.GB2935@thunk.org>
 <AANLkTikQoAbsKX=N-ST3KVqSxBnA6OhNvd7FehLDnn=V@mail.gmail.com>
 <20101106234029.GC2935@thunk.org>
 <alpine.DEB.2.00.1011061646170.29342@asgard.lang.hm>
 <20101107000348.GF2935@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101107000348.GF2935@thunk.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2010-11-06 20:03:48, Ted Ts'o wrote:
> On Sat, Nov 06, 2010 at 04:52:26PM -0700, david@lang.hm wrote:
> > also, none of these other patches resulted in device drivers
> > developed for a distro being incompatible with mainline.
> 
> What, people can't delete a couple of single lines of code before
> submitting the device driver upstream to mainline?  Here's the world's
> tiniest violin playing, "my heart bleeds for you"....

Deleting couple single liners is not a problem. Cleaning up 100KLoC
patch for mainline *is* a problem.

I know, I tried to do that work. Even getting it to staging quality
was hard, and it was recently dropped due to security holes.

Unfortunately google uses wakelocks as an excuse for not cleaning up
stuff... "because readding those few lines would be too hard".

	 	  	   	     	   	    	Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
