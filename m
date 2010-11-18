Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057Ab0KRBxX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 20:53:23 -0500
Received: from kroah.org ([198.145.64.141]:41518 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753963Ab0KRBxW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 20:53:22 -0500
Date: Wed, 17 Nov 2010 17:53:10 -0800
From: Greg KH <greg@kroah.com>
To: Lennart Poettering <mzxreary@0pointer.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Kay Sievers <kay.sievers@vrfy.org>,
        Valdis.Kletnieks@vt.edu, linux-kernel <linux-kernel@vger.kernel.org>,
        Werner Fink <werner@suse.de>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: tty: add 'active' sysfs attribute to tty0 and console device
Message-ID: <20101118015310.GA30480@kroah.com>
References: <AANLkTi=ju4fON7Hz=j_tFtqFGD0b-c=-Ou+HQwfYDgOy@mail.gmail.com>
 <20101116195538.7fa66b97@lxorguk.ukuu.org.uk>
 <20101116213622.GA17824@tango.0pointer.de>
 <20101116225619.5fa7ef8b@lxorguk.ukuu.org.uk>
 <20101116231023.GB27594@tango.0pointer.de>
 <25482.1290031268@localhost>
 <AANLkTimV_zKK-Ubw3vJkDUtrYvB+W06cRR7Nz2vam6fP@mail.gmail.com>
 <20101117235647.00766e32@lxorguk.ukuu.org.uk>
 <20101118012734.GA8558@kroah.com>
 <20101118014848.GA7873@tango.0pointer.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101118014848.GA7873@tango.0pointer.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 02:48:48AM +0100, Lennart Poettering wrote:
> On Wed, 17.11.10 17:27, Greg KH (greg@kroah.com) wrote:
> 
> > I can do any one, or multiple things from the following options:
> > 
> > 	- disable the existing ioctl to return an error so that no new
> > 	  userspace program starts to use it thinking it is valid
> > 	- accept Werner's patch for those who like proc files
> > 	- accept Kay's patch
> > 
> > Any suggestions?
> 
> Maybe this is not so surprising, but I definitely want item #3 from the
> list. 
> 
> I am against #2, since #1 is a much nicer solution, and having both
> would be needlessly redundant.

I think you mean s/1/3/ here, right?

And yes, having both will be redundant, and Werner seems to not be
responding anymore as to why he feels his patch is somehow still needed
given that Kay's patch accomplishes the same thing from what I can tell.

thanks,

greg k-h
