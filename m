Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412Ab0KCQNM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 12:13:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36328 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751797Ab0KCQNL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 12:13:11 -0400
Date: Wed, 3 Nov 2010 09:13:42 -0700
From: Greg KH <gregkh@suse.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        jirislaby@gmail.com, "[cleanups]"@suse.de,
        "Dr. Werner Fink" <werner@suse.de>, Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 1/1] console: add /proc/consoles
Message-ID: <20101103161342.GA4942@suse.de>
References: <1288798509-23550-1-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288798509-23550-1-git-send-email-jslaby@suse.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 03, 2010 at 04:35:09PM +0100, Jiri Slaby wrote:
> It allows users to see what consoles are currently known to the system
> and with what flags.
> 
> It is based on Werner's patch, the part about traversing fds was
> removed, the code was moved to kernel/printk.c, where consoles are
> handled and it makes more sense to me.

Why kernel/printk.c?  I don't think that makes sense, it's just a random
proc file, so why not put it into something like fs/proc/ instead?

Does it rely on any functions in the printk.c file?

thanks,

greg k-h
