Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617Ab2GZTUs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 15:20:48 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51620 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312Ab2GZTUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 15:20:47 -0400
Date: Thu, 26 Jul 2012 12:20:33 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: No big TTY/serial patch merge for 3.6-rc1
Message-ID: <20120726192033.GA3488@kroah.com>
References: <20120726190814.GA2194@kroah.com>
 <5011969D.5030902@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5011969D.5030902@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2012 at 09:12:29PM +0200, Jiri Slaby wrote:
> On 07/26/2012 09:08 PM, Greg KH wrote:
> > Jiri, I know this postpones your patches from being merged, sorry about
> > that, but this gives us a few more months to ensure that they are
> > working properly :)
> 
> Fine with me.
> 
> When should I send you 3.7 material I have in my local queue -- now or
> after 3.6-rc1 is out as usual?

After 3.6-rc1 is out is good, as I'll just be ignoring any new stuff
until then, with the exception of patches to fix build errors in the
tty-next tree :)

thanks,

greg k-h
