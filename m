Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933656Ab2GFXSL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 19:18:11 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:50640 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932579Ab2GFXSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 19:18:08 -0400
X-Sasl-enc: +d2urEx/A68elMx+Poq+FPk6T+ijspBZD5j0RzZVd1Ja 1341616687
Date: Fri, 6 Jul 2012 16:18:06 -0700
From: Greg KH <greg@kroah.com>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        ewust@umich.edu, zakir@umich.edu, nadiah@cs.ucsd.edu,
        jhalderm@umich.edu, Linus Torvalds <torvalds@linux-foundation.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH 05/12] usb: feed USB device information to the
 /dev/random driver
Message-ID: <20120706231806.GA2260@kroah.com>
References: <1341614704-24965-1-git-send-email-tytso@mit.edu>
 <1341614704-24965-6-git-send-email-tytso@mit.edu>
 <20120706230218.GD3728@burratino>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120706230218.GD3728@burratino>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 06, 2012 at 06:02:18PM -0500, Jonathan Nieder wrote:
> Hi,
> 
> Theodore Ts'o wrote:
> 
> > Send the USB device's serial, product, and manufacturer strings to the
> > /dev/random driver to help seed its pools.
> >
> > Cc: Linus Torvalds <torvalds@linux-foundation.org>
> > Acked-by: Greg KH <greg@kroah.com>
> > Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> > Cc: stable@vger.kernel.org
> 
> Why cc: stable@?  Does this fix a build error, oops, hang, data
> corruption, real security issue, or other critical "oh, that's not
> good" bug?
> 
> (I can imagine some reasons but I'm asking because it's not spelled
> out.)

It's part of the larger series that resolves issues with the random
number generator at boot time.  You want these patches backported, read
the original report for why.

hope this helps,

greg k-h
