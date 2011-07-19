Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001Ab1GSCXI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 22:23:08 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60403 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910Ab1GSCXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 22:23:07 -0400
Date: Tue, 19 Jul 2011 03:23:05 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        Nick Piggin <npiggin@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] vfs: fix race in rcu lookup of pruned dentry
Message-ID: <20110719022305.GO11013@ZenIV.linux.org.uk>
References: <alpine.LSU.2.00.1107181407060.3530@sister.anvils>
 <CA+55aFxq1KZycxXCwLARv0WOYG_-aim=e9kt=eLcNuymmeoyiA@mail.gmail.com>
 <alpine.LSU.2.00.1107181533590.3909@sister.anvils>
 <20110718231738.GJ11013@ZenIV.linux.org.uk>
 <20110718232114.GK11013@ZenIV.linux.org.uk>
 <CA+55aFzAK52MZXs1ZAdJhnKgnO8OnzUggvS67VUP4mgiYHi5kQ@mail.gmail.com>
 <20110718234012.GL11013@ZenIV.linux.org.uk>
 <alpine.LSU.2.00.1107181903350.23830@sister.anvils>
 <CA+55aFwafi1p=RgrwsauKw+40mcUx9nOs4pkvSFsGBmsb25dDQ@mail.gmail.com>
 <CA+55aFzMP3oYV9G8bzskkyNEpqcHGSBR3rWCF_TWF4QhOMmR8A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzMP3oYV9G8bzskkyNEpqcHGSBR3rWCF_TWF4QhOMmR8A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 18, 2011 at 07:17:18PM -0700, Linus Torvalds wrote:
> On Mon, Jul 18, 2011 at 7:14 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > Good catch, that test was indeed the wrong way around. Thanks.
> 
> Oh, and Al - just fold the thing into the original patch rather than
> carry a buggy patch and the fix around. You might as well credit Hugh
> as author for the whole thing, since he ended up being not just the
> one to find the problem, but describe the solution anyway and fix the
> patch.

Umm...  Is there any convenient way to make git commit --amend change
the author of commit?
