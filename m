Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810Ab1AWXvo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 18:51:44 -0500
Received: from tundra.namei.org ([65.99.196.166]:46970 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752282Ab1AWXvm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 18:51:42 -0500
Date: Mon, 24 Jan 2011 10:51:17 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: David Howells <dhowells@redhat.com>
cc: viro@zeniv.linux.org.uk, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        tomoyo-users-en@lists.sourceforge.jp,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] CacheFiles: Add calls to path-based security hooks [ver
 #2]
In-Reply-To: <20101224144834.22524.86008.stgit@warthog.procyon.org.uk>
Message-ID: <alpine.LRH.2.00.1101241050160.30043@tundra.namei.org>
References: <20101224144834.22524.86008.stgit@warthog.procyon.org.uk>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Dec 2010, David Howells wrote:

> Add calls to path-based security hooks into CacheFiles as, unlike inode-based
> security, these aren't implicit in the vfs_mkdir() and similar calls.
> 
> Reported-by: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp> 
> Signed-off-by: David Howells <dhowells@redhat.com>

Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next

-- 
James Morris
<jmorris@namei.org>
