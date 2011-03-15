Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752432Ab1COWSV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 18:18:21 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35537 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab1COWST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 18:18:19 -0400
Date: Tue, 15 Mar 2011 22:18:18 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [git pull] VFS - the first pile
Message-ID: <20110315221818.GN22723@ZenIV.linux.org.uk>
References: <20110315213248.GL22723@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110315213248.GL22723@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 15, 2011 at 09:32:48PM +0000, Al Viro wrote:
> Shortlog:
> Al Viro (45):
>       compat breakage in preadv() and pwritev()

BTW, a question about rebases: is that kind of situation worth doing
a rebase of the queue/backmerge/etc.?

This commit sits in the base of that branch, with branchpoint at Mar 10;
the same thing had been applied in mainline at Mar 13.  git merge does,
of course, handle it just fine; I guess I should've posted a pull request
back then instead of posting the patch - to be honest, I hadn't thought
about that.

What's the prefered way of dealing with such situations?  Leave as is?
Rebase at the point where the patch went into mainline?  Something else?
