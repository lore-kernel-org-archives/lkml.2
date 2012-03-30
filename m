Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934489Ab2C3UEz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 16:04:55 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:43966 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934128Ab2C3UEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 16:04:53 -0400
Date: Fri, 30 Mar 2012 16:04:47 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Btrfs fixes and features
Message-ID: <20120330200447.GL755@shiny>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <20120330175106.GB755@shiny>
 <CA+55aFwFkeR8pNo7dF1gr0VPD9hr+9zB8zoc_byvMxSzr2WEZw@mail.gmail.com>
 <CA+55aFyn0TL6vJZrGVQkgAscT33nf9_7rH-DRVJbcG3K7d7QKA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFyn0TL6vJZrGVQkgAscT33nf9_7rH-DRVJbcG3K7d7QKA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-CT-RefId: str=0001.0A090205.4F7611E4.0044,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2012 at 12:54:03PM -0700, Linus Torvalds wrote:
> On Fri, Mar 30, 2012 at 12:50 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > This causes a new warning for me:
> >
> >  fs/btrfs/extent_io.c: In function ‘repair_eb_io_failure’:
> >  fs/btrfs/extent_io.c:1940:6: warning: ‘ret’ may be used
> > uninitialized in this function
> >
> > Hmm?
> 
> Ok, so presumably num_pages (which is "num_extent_pages(eb->start,
> eb->len)") cannot be zero, so I guess the code is ok. But gcc can't
> know that, and it's an annoying warning.

Whoops, my reply was too slow, sorry.  If you're curious my gcc that
doesn't warn in 4.6.3.

> 
> So please fix, but it's not urgent. In the meantime I've pulled and pushed out.

Ok, I'll send just the incremental in a later pull.

-chris
