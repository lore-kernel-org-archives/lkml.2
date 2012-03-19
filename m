Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758880Ab2CSSmD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 14:42:03 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37494 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756530Ab2CSSmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 14:42:01 -0400
Date: Mon, 19 Mar 2012 11:41:57 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: Santiago Garcia Mantinan <manty@debian.org>, linux-kernel@vger.kernel.org,
        Matthias Urlichs <smurf@smurf.noris.de>, linux-usb@vger.kernel.org,
        Dirk De Schepper <ddeschepper@nvtl.com>, digidietze@draisberghof.de
Subject: Re: [RFC/PATCH] USB: option: handle Novatel 3G modem 1410:7001 out
 of the box again
Message-ID: <20120319184157.GB4006@kroah.com>
References: <20120319102154.GA16536@www.manty.net>
 <20120319150801.GC11180@burratino>
 <20120319171659.GA27498@www.manty.net>
 <20120319182521.GC13707@burratino>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120319182521.GC13707@burratino>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2012 at 01:25:21PM -0500, Jonathan Nieder wrote:
> From: Santiago Garcia Mantinan <manty@debian.org>
> Date: Mon, 19 Mar 2012 18:17:00 +0100
> 
> Since commit c7aa8f44b4d1 ("USB: option: fix incorrect novatel
> entries"), the Novatel Mifi 2372 (USB id 1410:7001) is not recognized
> by the option driver.  That commit removed that id from the list of
> supported ids for no obvious reason --- perhaps it was just lost in
> the shuffle.
> 
> Addresses http://bugs.debian.org/664605 and
>           https://bugs.launchpad.net/bugs/750362
> 
> Signed-off-by: Santiago Garcia Mantinan <manty@debian.org>
> Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
> Cc: <stable@vger.kernel.org> # >= 2.6.36
> ---
> Santiago Garcia Mantinan wrote:
> 
> > here it goes with full paths on the patch ...
> 
> Great.  Here is the same with a commit message and all. ;-)  linux-usb
> folks, what do you think?

Looks good, thanks, I'll queue it up after I get this latest round of
patches all off to Linus.  That means I will not be able to get to it
probably until after 3.4-rc1 is out, but don't worry, it's not lost.

thanks,

greg k-h
