Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934323Ab2JXDAe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 23:00:34 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:36245 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933993Ab2JXDAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 23:00:33 -0400
Date: Tue, 23 Oct 2012 20:01:05 -0700
From: "'Greg KH'" <gregkh@linuxfoundation.org>
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, arnd@arndb.de, tytso@mit.edu,
        chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com
Subject: Re: [PATCH 00/16 v2] f2fs: introduce flash-friendly file system
Message-ID: <20121024030105.GC7982@kroah.com>
References: <001001cdb0c5$2ac96520$805c2f60$%kim@samsung.com>
 <20121023182659.GA6587@kroah.com>
 <012e01cdb174$3068f540$913adfc0$%kim@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <012e01cdb174$3068f540$913adfc0$%kim@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 08:14:44AM +0900, Jaegeuk Kim wrote:
> > On Tue, Oct 23, 2012 at 11:21:53AM +0900, Jaegeuk Kim wrote:
> > > mkfs.f2fs
> > > =========
> > >
> > > The file system formatting tool, "mkfs.f2fs", is available from the following
> > > download page:		http://sourceforge.net/projects/f2fs-tools/
> > 
> > Is there a git tree of this tool somewhere, so I don't have to
> > constantly suffer the sf.net download interface every time I want to get
> > the latest version?
> 
> I'd love to do like that.
> I've managed a git tree for tools in house only, due to the company secret.
> Would you suggest something for this?
> I can do managing the tree outside though.

git.kernel.org can work, so can github, and also, you have a sf.net
project, why not use the git tree it provides you?  Right now it is
empty.

thanks,

greg k-h
