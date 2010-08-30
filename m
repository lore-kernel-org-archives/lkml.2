Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291Ab0H3UAE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 16:00:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33188 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755157Ab0H3UAB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 16:00:01 -0400
Date: Mon, 30 Aug 2010 11:47:37 -0700
From: Greg KH <gregkh@suse.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/5] tty: move stuff around
Message-ID: <20100830184737.GA21339@suse.de>
References: <1283115995-4734-1-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283115995-4734-1-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 29, 2010 at 11:06:30PM +0200, Arnd Bergmann wrote:
> Hi Greg,
> 
> After fighting with the BKL removal in tty, I realized that the
> files in drivers/char could use a reorganization to split the
> tty files from those drivers that have nothing to do with ttys.

<snip>

I like the idea, and after you've worked out with Alan which ones should
be "deleted" and others moved around, I'll be glad to apply these types
of patches.

Oh, we shouldn't just delete the drivers, we can move them to
drivers/staging/ where they will then be removed after 2 kernel releases
if no one steps up to fix/maintain them.  That's the "proper" way to
depreciate a driver.

> Of course, moving stuff around always has the tendency to
> break patches against it, so we might not want to do this after
> all.

Nah, it's no problem to this, git can handle renames just fine :)

thanks,

greg k-h
