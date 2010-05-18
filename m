Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757424Ab0ERNR2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 09:17:28 -0400
Received: from nessie.weebeastie.net ([220.233.7.36]:42909 "EHLO
	bunyip.billabong.weebeastie.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756199Ab0ERNR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 09:17:26 -0400
Date: Tue, 18 May 2010 23:17:06 +1000
From: CaT <cat@zip.com.au>
To: Greg KH <greg@kroah.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, bzolnier@gmail.com,
       stable@kernel.org, ben@decadent.org.uk,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.34 (rt2860 regression)
Message-ID: <20100518131706.GZ2657@zip.com.au>
References: <alpine.LFD.2.00.1005161430100.4195@i5.linux-foundation.org> <20100518114426.GY2657@zip.com.au> <20100518125539.GA23181@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100518125539.GA23181@kroah.com>
Organisation: Furball Inc.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 18, 2010 at 05:55:39AM -0700, Greg KH wrote:
> I do not understand.  The firmware is now part of the linux-firmware
> tree, and if you install that, it is working just fine, right?  We moved
> the firmware out of the kernel tree on purpose.
> 
> So what is the problem here?

Well, the driver used to work and appears to be useless without it. I guess
I'm wondering why it was kept out of the firmware directory where all the
other firmware lives (and so allow the driver to simply continue to work
and allow it to be compiled in).

At the moment all the change appears to have done is break things that have
been working without issue since before the driver was even in staging.

-- 
  "A search of his car uncovered pornography, a homemade sex aid, women's 
  stockings and a Jack Russell terrier."
    - http://www.news.com.au/story/0%2C27574%2C24675808-421%2C00.html
