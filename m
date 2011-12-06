Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751863Ab1LFQlu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 11:41:50 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:36606 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330Ab1LFQlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 11:41:49 -0500
Date: Tue, 6 Dec 2011 16:41:47 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [git pull] apparmor fix for __d_path() misuse
Message-ID: <20111206164147.GJ2203@ZenIV.linux.org.uk>
References: <20111206154854.GH2203@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111206154854.GH2203@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 06, 2011 at 03:48:54PM +0000, Al Viro wrote:
> 	Fix for use-after-free race in apparmor d_namespace_path() and
> partially sanitizing the atrocious __d_path() API that has caused that
> mess in the first place.  Please, pull from
> git://git.kernel.org:/pub/scm/linux/kernel/git/viro/vfs.git for-linus

Argh...  Dumb typo when copying jj's fixlet; fixed almost immediately,
but not committed before push.  Noticed only when switching branches...

Is there any way to have git to complain if you are pushing the current
branch with uncommitted changes in your repository?

Anyway, fix commit --amend'ed and pushed into the same branch.  Neither
diffstats nor changelog changed on that, of course...

Al, hoping Linus still hasn't pulled that one...
