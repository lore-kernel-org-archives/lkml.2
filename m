Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407Ab2JWS55 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 14:57:57 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54486 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756975Ab2JWS5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 14:57:54 -0400
Date: Tue, 23 Oct 2012 11:57:53 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, arnd@arndb.de, tytso@mit.edu,
        chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com
Subject: Re: [PATCH 00/16 v2] f2fs: introduce flash-friendly file system
Message-ID: <20121023185753.GA2466@kroah.com>
References: <001001cdb0c5$2ac96520$805c2f60$%kim@samsung.com>
 <20121023182659.GA6587@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121023182659.GA6587@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 11:26:59AM -0700, Greg KH wrote:
> On Tue, Oct 23, 2012 at 11:21:53AM +0900, Jaegeuk Kim wrote:
> > mkfs.f2fs
> > =========
> > 
> > The file system formatting tool, "mkfs.f2fs", is available from the following
> > download page:		http://sourceforge.net/projects/f2fs-tools/
> 
> Is there a git tree of this tool somewhere, so I don't have to
> constantly suffer the sf.net download interface every time I want to get
> the latest version?

Oh, and where do we report bugs for this tool?  I just formatted a usb
stick with the mkfs.f2fs program, and it did not fully erase the old
filesystem that was on there (iso9660), so when I mounted it, it did so
in iso9660 mode, not f2fs mode.

thanks,

greg k-h
