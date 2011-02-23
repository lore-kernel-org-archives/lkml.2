Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464Ab1BWSJW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 13:09:22 -0500
Received: from cantor.suse.de ([195.135.220.2]:45849 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751422Ab1BWSJV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 13:09:21 -0500
Date: Wed, 23 Feb 2011 10:02:44 -0800
From: Greg KH <gregkh@suse.de>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [GIT PATCH] USB fixes for .38
Message-ID: <20110223180244.GA30106@suse.de>
References: <20110222232703.GA18987@kroah.com>
 <4D654626.40901@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D654626.40901@ru.mvista.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 08:38:46PM +0300, Sergei Shtylyov wrote:
> >Johan Hovold (2):
> >       usb: musb: omap2430: fix kernel panic on reboot
> >       USB: musb: omap2430: fix kernel panic on reboot
> 
>    It's the same patch repeated twice. I wonder how it was possible
> without an intevening revert... :-O

Welcome to git, the amazing tool that can handle duplicate patches on
different branches, and when merged it knows what to do to resolve the
issue (i.e. nothing as everything is just fine.)

And yes, I know this happened, and I even posted to the linux-usb list
when it did, so it shouldn't have been a surprise to anyone.

thanks,

greg k-h
