Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757133Ab0LJUad (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 15:30:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37424 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757113Ab0LJUaa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 15:30:30 -0500
Date: Fri, 10 Dec 2010 12:22:50 -0800
From: Greg KH <gregkh@suse.de>
To: Andy Walls <awalls@md.metrocast.net>
Cc: Greg KH <greg@kroah.com>, mchehab@redhat.com, stable@kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        hverkuil@xs4all.nl
Subject: Re: [stable] [RESEND][PATCH for stable 2.6.36 REGRESSION] cx25840:
 Prevent device probe failure due to volume control ERANGE error]
Message-ID: <20101210202250.GA23699@suse.de>
References: <1291987197.2064.8.camel@morgan.silverblock.net>
 <20101210181630.GA12772@kroah.com>
 <1292010063.29254.13.camel@morgan.silverblock.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292010063.29254.13.camel@morgan.silverblock.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 10, 2010 at 02:41:03PM -0500, Andy Walls wrote:
> On Fri, 2010-12-10 at 10:16 -0800, Greg KH wrote:
> > On Fri, Dec 10, 2010 at 08:19:57AM -0500, Andy Walls wrote:
> > > Resending, since this didn't appear to make its way into in 2.6.36.2.
> > 
> > That's because it's not in Linus's tree, right?  I have to wait for that
> > to happen before I can add it to a stable tree.
> 
> Greg,
> 
> I wasn't aware of that constraint in the process, but it makes sense to
> me.

Please read Documentation/stable_kernel_rules.txt for what the process
is, and how to get patches into the stable kernel releases.

thanks,

greg k-h
