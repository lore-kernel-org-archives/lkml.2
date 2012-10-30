Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759589Ab2J3TiE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 15:38:04 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:41357 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724Ab2J3TiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 15:38:02 -0400
Date: Tue, 30 Oct 2012 22:35:35 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] zram: permit sleeping while in pool zs_malloc()
Message-ID: <20121030193535.GE2454@swordfish>
References: <20121030090319.GB5052@swordfish.minsk.epam.com>
 <20121030180439.GA3350@kroah.com>
 <20121030184911.GA2454@swordfish>
 <20121030191809.GA1868@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121030191809.GA1868@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (10/30/12 12:18), Greg Kroah-Hartman wrote:
> > the first one:
> > 
> > [PATCH 1/2] zram: factor-out zram_decompress_page() function
> > [PATCH 2/2] zram: handle mem suffixes in disk size zram_sysfs parameter
> > 
> > ACKed by Nitin.
> >  
> > the second one
> > 
> > [PATCH 2/2] zram: permit sleeping while in pool zs_malloc()
> > [PATCH 1/2] zram: forbid IO operations from within zram_init_device()  -- droppped by me.
> > 
> > 
> > I'll resend first two and next time will make sure not to spam your box. sorry.
> 
> Sending me lots of patches is fine, I don't mind that at all.  It's what
> I'm here for it seems :)
> 
> But when there is responses, and follow-up patches, and second versions
> and lots of other stuff, it gets hard to follow, so I ask for them all
> to be resent, like this.
> 

I'll Cc you next time only when we land the final versions.


> But, what happened with your second series?  As you didn't resend them,
> I'll just ignore them for now, please resend if you ever get them worked
> out.
> 

please ignore as I didn't have any response from Nitin yet on them. 

	-ss

> thanks,
> 
> greg k-h
> 
