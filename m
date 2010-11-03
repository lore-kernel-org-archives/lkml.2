Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607Ab0KCQWb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 12:22:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36532 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752353Ab0KCQW3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 12:22:29 -0400
Date: Wed, 3 Nov 2010 09:22:51 -0700
From: Greg KH <gregkh@suse.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        jirislaby@gmail.com, "[cleanups]"@suse.de,
        "Dr. Werner Fink" <werner@suse.de>, Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 1/1] console: add /proc/consoles
Message-ID: <20101103162251.GA5404@suse.de>
References: <1288798509-23550-1-git-send-email-jslaby@suse.cz> <20101103161342.GA4942@suse.de> <4CD18ACB.4060108@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CD18ACB.4060108@suse.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 03, 2010 at 05:16:11PM +0100, Jiri Slaby wrote:
> On 11/03/2010 05:13 PM, Greg KH wrote:
> > On Wed, Nov 03, 2010 at 04:35:09PM +0100, Jiri Slaby wrote:
> >> It allows users to see what consoles are currently known to the system
> >> and with what flags.
> >>
> >> It is based on Werner's patch, the part about traversing fds was
> >> removed, the code was moved to kernel/printk.c, where consoles are
> >> handled and it makes more sense to me.
> > 
> > Why kernel/printk.c?  I don't think that makes sense, it's just a random
> > proc file, so why not put it into something like fs/proc/ instead?
> > 
> > Does it rely on any functions in the printk.c file?
> 
> No it doesn't. I will move it to fs/proc/ if that's preferred. I checked
> how VM proc stuff is handled and it was in in mm/, so I put this into
> kernel/...
> 
> (Then it will depend on the console cleanup series which I sent few
> minutes ago...)

That's fine, I can take those through my tree as well, as it makes sense
to do so.

thanks,

greg k-h
