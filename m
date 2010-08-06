Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762061Ab0HFUfH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 16:35:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33698 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762019Ab0HFUfD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 16:35:03 -0400
Date: Fri, 6 Aug 2010 13:22:28 -0700
From: Greg KH <gregkh@suse.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] TTY patches for 2.6.36
Message-ID: <20100806202228.GA6153@suse.de>
References: <20100805213528.GA13794@kroah.com>
 <20100806204552.7cb80fd0@lxorguk.ukuu.org.uk>
 <AANLkTimGoG97dtp_hmHBJwwo1stzZxLoKs4_jr+eQ=gJ@mail.gmail.com>
 <201008062158.46013.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201008062158.46013.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 06, 2010 at 09:58:45PM +0200, Arnd Bergmann wrote:
> On Friday 06 August 2010 21:38:36 Linus Torvalds wrote:
> > I also don't want the BKL to show up in grep, even if the config
> > option for it were to be impossible to enable. If we've gotten far
> > enough that we can get rid of the BKL in the tty layer, we really
> > should get rid of it. Not leave it in some zombie limbo state.
> 
> Ok, I've sent the replacement patch that does this, and I'm much
> happier with the outcome.
> 
> If you apply this version, the only stronghold left for the BKL
> will be fs/lockd, everything else that's left is either simple
> to fix or highly obscure.

Ok, I got that one now, and am building the tree to test here before
sending to Linus.

thanks,

greg k-h
