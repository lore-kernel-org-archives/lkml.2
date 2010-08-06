Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761923Ab0HFSwG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 14:52:06 -0400
Received: from cantor.suse.de ([195.135.220.2]:36539 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761729Ab0HFSwC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 14:52:02 -0400
Date: Fri, 6 Aug 2010 11:51:47 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] TTY patches for 2.6.36
Message-ID: <20100806185147.GB23853@suse.de>
References: <20100805213528.GA13794@kroah.com>
 <AANLkTikhq6FF4j+w-TXrPeq05NhvbhgqhJkW7tCw2+3c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikhq6FF4j+w-TXrPeq05NhvbhgqhJkW7tCw2+3c@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 06, 2010 at 11:40:15AM -0700, Linus Torvalds wrote:
> 
> Do do the highlander thing on that crud. Cut it off at the head, and
> make sure it never ever comes back to life.

Arnd and Alan, I'll drop the BKL portion of this patch series and
regenerate something to get the other tty patches to Linus.

Care to redo the patch series and just drop the BKL for good?

thanks,

greg k-h
