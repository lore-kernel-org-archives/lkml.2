Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416Ab2J3TSP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 15:18:15 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:57990 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110Ab2J3TSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 15:18:14 -0400
Date: Tue, 30 Oct 2012 12:18:09 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Nitin Gupta <ngupta@vflare.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] zram: permit sleeping while in pool zs_malloc()
Message-ID: <20121030191809.GA1868@kroah.com>
References: <20121030090319.GB5052@swordfish.minsk.epam.com>
 <20121030180439.GA3350@kroah.com>
 <20121030184911.GA2454@swordfish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121030184911.GA2454@swordfish>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2012 at 09:49:11PM +0300, Sergey Senozhatsky wrote:
> On (10/30/12 11:04), Greg Kroah-Hartman wrote:
> > On Tue, Oct 30, 2012 at 12:03:19PM +0300, Sergey Senozhatsky wrote:
> > >     zram: permit sleeping while in pool zs_malloc()
> > 
> > 2/2?  Huh?  Where is 1/2?
> > 
> > I have a raft of patches from you, all out of order, and full of
> > responses from Nitin, and so, I really have no idea what should and
> > should not be applied here.
> > 
> > So, I'm dropping them all.  Please work with Nitin to get a series of
> > patches that are acceptable and resend them with the proper numbering.
> > 
> 
> those were two separate series.
> 
> the first one:
> 
> [PATCH 1/2] zram: factor-out zram_decompress_page() function
> [PATCH 2/2] zram: handle mem suffixes in disk size zram_sysfs parameter
> 
> ACKed by Nitin.
> 
> 
> 
> the second one
> 
> [PATCH 2/2] zram: permit sleeping while in pool zs_malloc()
> [PATCH 1/2] zram: forbid IO operations from within zram_init_device()  -- droppped by me.
> 
> 
> I'll resend first two and next time will make sure not to spam your box. sorry.

Sending me lots of patches is fine, I don't mind that at all.  It's what
I'm here for it seems :)

But when there is responses, and follow-up patches, and second versions
and lots of other stuff, it gets hard to follow, so I ask for them all
to be resent, like this.

But, what happened with your second series?  As you didn't resend them,
I'll just ignore them for now, please resend if you ever get them worked
out.

thanks,

greg k-h
