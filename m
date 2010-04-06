Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234Ab0DFRLk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 13:11:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54438 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753018Ab0DFRLe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 13:11:34 -0400
Date: Wed, 7 Apr 2010 03:11:21 +1000
From: Nick Piggin <npiggin@suse.de>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Anton Altaparmakov <aia21@cantab.net>,
       Al Viro <viro@zeniv.linux.org.uk>, Jiri Kosina <jkosina@suse.cz>,
       Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org,
       linux-ntfs-dev@lists.sourceforge.net
Subject: Re: [PATCH 2/2] ntfs: use add_to_page_cache_lru
Message-ID: <20100406171121.GI5288@laptop>
References: <1270482365.1814.138.camel@barrios-desktop>
 <20100406154728.GF5288@laptop>
 <r2s28c262361004060930u95af7d62k5136aeb67c8d7019@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <r2s28c262361004060930u95af7d62k5136aeb67c8d7019@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 07, 2010 at 01:30:24AM +0900, Minchan Kim wrote:
> Hi, Nick.
> 
> On Wed, Apr 7, 2010 at 12:47 AM, Nick Piggin <npiggin@suse.de> wrote:
> > On Tue, Apr 06, 2010 at 12:46:05AM +0900, Minchan Kim wrote:
> >>
> >> While I discuss exportable add_to_page_cache_lru,
> >> http://marc.info/?l=linux-mm&m=127047788612445&w=2
> >> I found that
> >> http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg04472.html.
> >>
> >> Let's change to use it in ntfs.
> >
> > Thanks, I went through most filesystems and changed it in those too,
> > including ntfs. Haven't had much feedback but I'll just send the
> > patches to Andrew if they haven't been merged by next release.
> >
> 
> Please, let me know it.
> That's because actually I had a plan to change about some filesystem.
> If you already did it, I don't need to do. :)

I did most of them and cc'ed linux-fsdevel last month. btrfs, cifs,
nfs, ntfs. If you find any others, fix em up :)

