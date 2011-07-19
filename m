Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992Ab1GSElI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 00:41:08 -0400
Received: from relais.videotron.ca ([24.201.245.36]:11631 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123Ab1GSElG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 00:41:06 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Tue, 19 Jul 2011 00:41:04 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nick Piggin <npiggin@kernel.dk>, lkml <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] vfs: fix race in rcu lookup of pruned dentry
In-reply-to: <20110719022305.GO11013@ZenIV.linux.org.uk>
Message-id: <alpine.LFD.2.00.1107190036490.21187@xanadu.home>
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
 <20110719022305.GO11013@ZenIV.linux.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jul 2011, Al Viro wrote:

> On Mon, Jul 18, 2011 at 07:17:18PM -0700, Linus Torvalds wrote:
> > On Mon, Jul 18, 2011 at 7:14 PM, Linus Torvalds
> > <torvalds@linux-foundation.org> wrote:
> > >
> > > Good catch, that test was indeed the wrong way around. Thanks.
> > 
> > Oh, and Al - just fold the thing into the original patch rather than
> > carry a buggy patch and the fix around. You might as well credit Hugh
> > as author for the whole thing, since he ended up being not just the
> > one to find the problem, but describe the solution anyway and fix the
> > patch.
> 
> Umm...  Is there any convenient way to make git commit --amend change
> the author of commit?

	git commit --amend --author="Hugh Dickins <hughd@google.com>"


Nicolas
