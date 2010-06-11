Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760043Ab0FKBnA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 21:43:00 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39420 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754052Ab0FKBm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 21:42:58 -0400
Date: Fri, 11 Jun 2010 02:42:53 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, tytso@mit.edu,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/1] VFS: introduce s_dirty accessors
Message-ID: <20100611014253.GE31073@ZenIV.linux.org.uk>
References: <1276167393-31492-1-git-send-email-dedekind1@gmail.com>
 <1276167393-31492-2-git-send-email-dedekind1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276167393-31492-2-git-send-email-dedekind1@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 10, 2010 at 01:56:33PM +0300, Artem Bityutskiy wrote:
> From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> 
> This patch introduces 3 VFS accessors: 'sb_mark_dirty()',
> 'sb_mark_clean()', and 'sb_is_dirty()'. They simply
> set 'sb->s_dirt' or test 'sb->s_dirt'. The plan is to make
> every FS use these accessors later instead of manipulating
> the 'sb->s_dirt' flag directly.
> 
> Ultimately, this change is a preparation for the periodic
> superblock synchronization optimization which is about
> preventing the "sync_supers" kernel thread from waking up
> even if there is nothing to synchronize.
> 
> This patch does not do any functional change, just adds
> accessor functions.

Applied and pushed.  It's in for-next, which should do until Linus
comes back and picks it...
