Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757987Ab0FIQcs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 12:32:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53263 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752326Ab0FIQcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 12:32:45 -0400
Date: Wed, 9 Jun 2010 09:31:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: tytso@mit.edu
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Artem Bityutskiy <dedekind1@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>,
       linux-fsdevel@vger.kernel.org, Roman Zippel <zippel@linux-m68k.org>,
       "Tigran A. Aivazian" <tigran@aivazian.fsnet.co.uk>,
       Chris Mason <chris.mason@oracle.com>,
       Boaz Harrosh <bharrosh@panasas.com>, linux-ext4@vger.kernel.org,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       David Woodhouse <dwmw2@infradead.org>, reiserfs-devel@vger.kernel.org,
       Jan Kara <jack@suse.cz>, Evgeniy Dushistov <dushistov@mail.ru>
Subject: Re: [PATCHv4 01/17] VFS: introduce helpers for the s_dirty flag
Message-Id: <20100609093157.cd040633.akpm@linux-foundation.org>
In-Reply-To: <20100609154448.GC6162@thunk.org>
References: <1274795352-3551-1-git-send-email-dedekind1@gmail.com>
	<1274795352-3551-2-git-send-email-dedekind1@gmail.com>
	<20100528132318.0783675a.akpm@linux-foundation.org>
	<20100528211432.GM31073@ZenIV.linux.org.uk>
	<20100528141755.42958d81.akpm@linux-foundation.org>
	<20100609154448.GC6162@thunk.org>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Jun 2010 11:44:49 -0400 tytso@mit.edu wrote:

> On Fri, May 28, 2010 at 02:17:55PM -0700, Andrew Morton wrote:
> > > 
> > > The real issue is that it's almost certainly an overdesign.  Let's
> > > get rid of the bogus uses first and figure out what's happening in
> > > what remains, OK?
> > 
> > That would be good.
> 
> Can we figure out what the new names will be for these accessor
> functions,

sb_mark_dirty(), sb_mark_clean(), sb_is_dirty().

> and then pursuade Linus to be willing to add patch #1 in
> this series to add these accessor functions (without any users for
> these functions, that would wait until the next merge window) to
> 2.6.35-rc3 or -rc4, please?

I expect he'd be OK with that.

> It will make life much easier for fs maintainers to merge the patches,
> especially if they've done some cleanup to reduce the bogus places
> where s_dirt was getting set in the first place.

For that reason.

