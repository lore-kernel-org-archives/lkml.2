Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933162Ab1JZNiK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 09:38:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41802 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933123Ab1JZNiI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 09:38:08 -0400
Date: Wed, 26 Oct 2011 15:34:38 +0200
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [GIT PATCH] TTY/serial driver patches for 3.2
Message-ID: <20111026133438.GA26336@suse.de>
References: <20111026114236.GA22180@kroah.com>
 <CA+55aFycM+nHxJNnFSjEXQvZkeBfHu161ePC0=7sWKZR1toQNA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFycM+nHxJNnFSjEXQvZkeBfHu161ePC0=7sWKZR1toQNA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 26, 2011 at 03:18:21PM +0200, Linus Torvalds wrote:
> On Wed, Oct 26, 2011 at 1:42 PM, Greg KH <gregkh@suse.de> wrote:
> >
> > The one in 8250_pci.c is trivial to fix, the atmel_serial one isn't as
> > easy, but I'm sure you can figure it out :)  If you want me to do the
> > merge for it, I'll be glad to do so, just let me know.
> 
> So I figured it out, but please double-check, especially since it
> seems to be some arm-only driver that I can't even compile-test my
> resolution.

I think it looks correct, but yeah, as I can't build it either, it's
tough to tell.

Nicolas, can you verify that Linus's merge was done correctly?  If not,
can you send a patch?  It is commit
efb8d21b2c6db3497655cc6a033ae8a9883e4063 in Linus's tree right now.

thanks,

greg k-h
