Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430Ab1COXCu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 19:02:50 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48075 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852Ab1COXCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 19:02:49 -0400
Date: Tue, 15 Mar 2011 23:02:48 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [git pull] VFS - the first pile
Message-ID: <20110315230248.GO22723@ZenIV.linux.org.uk>
References: <20110315213248.GL22723@ZenIV.linux.org.uk>
 <20110315221818.GN22723@ZenIV.linux.org.uk>
 <AANLkTi=BgLcfw-XyJRw52eiUSf9=oF6oUQKEVTtWB51K@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=BgLcfw-XyJRw52eiUSf9=oF6oUQKEVTtWB51K@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 15, 2011 at 03:47:55PM -0700, Linus Torvalds wrote:
> On Tue, Mar 15, 2011 at 3:18 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > BTW, a question about rebases: is that kind of situation worth doing
> > a rebase of the queue/backmerge/etc.?
> 
> No. If it's the same patch I already applied, it will generally merge
> cleanly, it's better to leave in the history than to rewrite things
> just to avoid some trivial duplication.

It is and it does.  OK, then...
