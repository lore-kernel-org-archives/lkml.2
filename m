Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837Ab2BLVUK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 16:20:10 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:47149 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753929Ab2BLVUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 16:20:08 -0500
Date: Sun, 12 Feb 2012 21:20:03 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Richard Weinberger <richard@nod.at>
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] um: Cleanup headers files
Message-ID: <20120212212003.GU23916@ZenIV.linux.org.uk>
References: <20120130192552.GL23916@ZenIV.linux.org.uk>
 <1328311063-17630-1-git-send-email-richard@nod.at>
 <20120204001431.GY23916@ZenIV.linux.org.uk>
 <4F2C7F7A.1090605@nod.at>
 <20120212202728.GR23916@ZenIV.linux.org.uk>
 <4F3828BD.7070809@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F3828BD.7070809@nod.at>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 12, 2012 at 10:01:49PM +0100, Richard Weinberger wrote:
> Am 12.02.2012 21:27, schrieb Al Viro:
> >>So, I pulled your work and merged it into my shiny new UML tree:
> >>git://git.kernel.org/pub/scm/linux/kernel/git/rw/uml.git
> >
> >Hmm...  I would really, really recommend you to clean the git history in that
> >tree up.  As it is, you have
> >	* merge of that branch from um-headers
> >	* um: Switch to large mcmodel on x86_64
> >	* um: Serve io_remap_pfn_range()
> >	* 205 merges from Linus, from mid-April to late January.
> >	* mismerge from Linus on April 14; the diff between the result
> 
> Okay, I'll create a new tree. This one is definitely screwed.
> Sorry for the inconvenience.

Just create a new branch in the old one, populate it, verify that the
tree is what you want it to be, switch to your regular branch,
git reset --hard <the branch you've just built>, then git push --force
It's not worse than removal of old tree and replacing it with new one,
and it's less work...
