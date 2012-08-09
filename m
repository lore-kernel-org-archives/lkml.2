Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031072Ab2HIPR4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 11:17:56 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61882 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030785Ab2HIPRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 11:17:53 -0400
Date: Thu, 9 Aug 2012 08:17:49 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Antonio Quartulli <ordex@autistici.org>,
        Sven Eckelmann <sven@narfation.org>
Subject: Re: [ 029/109] batman-adv: fix skb->data assignment
Message-ID: <20120809151749.GB17409@kroah.com>
References: <20120807222043.089735600@linuxfoundation.org>
 <20120807222045.656376771@linuxfoundation.org>
 <1344477233.13142.204.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344477233.13142.204.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2012 at 02:53:53AM +0100, Ben Hutchings wrote:
> On Tue, 2012-08-07 at 15:34 -0700, Greg Kroah-Hartman wrote:
> > From: Greg KH <gregkh@linuxfoundation.org>
> > 
> > 3.4-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Antonio Quartulli <ordex@autistici.org>
> > 
> > commit d2b6cc8e460494251442a877fcbc150faa175b4f upstream.
> [...]
> 
> This was applied to David Miller's net-next, but then also on net as
> commit 2c995ff892313009e336ecc8ec3411022f5b1c39 upstream, which you've
> already applied as commit a7faba5c5263f9d8a31b3f542a0504552fa80932 in
> v3.4.5.
> 
> This inserts the assignment a second time, which is harmless but weird.
> So please drop it.

Now dropped, thanks.

greg k-h
