Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937Ab2AaBNa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 20:13:30 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38794 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752166Ab2AaBN2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 20:13:28 -0500
Date: Mon, 30 Jan 2012 17:11:01 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [GIT PATCH] TTY/serial patches for 3.3-rc1
Message-ID: <20120131011101.GA31748@suse.de>
References: <20120130211241.GA12941@kroah.com>
 <CA+55aFxFtsOj+9RYQGj+WEk3ovg4+d_syn8TooKjvBq2_B463Q@mail.gmail.com>
 <CA+55aFxGf8-Bv8Jrhm1dbTg6AkTi37Vfuw5OOC7hDokKRa4hjw@mail.gmail.com>
 <20120131001308.GB20588@suse.de>
 <CA+55aFxXwZmhC4USJSOk_itatwkg1m8gkQRTqKHNRGDWD8MCOw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxXwZmhC4USJSOk_itatwkg1m8gkQRTqKHNRGDWD8MCOw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 30, 2012 at 04:27:22PM -0800, Linus Torvalds wrote:
> On Mon, Jan 30, 2012 at 4:13 PM, Greg KH <gregkh@suse.de> wrote:
> >
> > Or I can spend the time to get the new version of git installed.
> > Wrestling with my scripts or rpm, I don't know which is worse...
> 
> Why do either?
> 
> The sane way to do things is to just
> 
>     cd
>     mkdir src
>     cd src
>     git clone git://github.com/gitster/git
>     cd git
>     make
>     make install
> 
> all as a regular user. It will install in your $(HOME)/bin, so just
> put that first in the path. No need to fight rpm, no need to fight
> your scripts, you should be pretty much all done.

Nice, for some reason I thought it would do the horrible /usr/local/
thing, and get all messed up with the installed version.

Ok, now done, so much for fighting with rpm, thanks, that made my day.

greg k-h
