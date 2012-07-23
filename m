Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994Ab2GWGJP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 02:09:15 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47113 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960Ab2GWGJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 02:09:14 -0400
Date: Mon, 23 Jul 2012 07:09:09 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: Re: [git pull] vfs.git; pile 1
Message-ID: <20120723060909.GE31729@ZenIV.linux.org.uk>
References: <20120722100920.GZ31729@ZenIV.linux.org.uk>
 <CA+55aFzG9gzWRLvZMb6RnKua0=RHxBFisYSCVDNhjHBq7oq2yw@mail.gmail.com>
 <20120722202030.GB31729@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120722202030.GB31729@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 22, 2012 at 09:20:30PM +0100, Al Viro wrote:
> Result: for-linus-2 + v3.5 and for-linus + v3.5 give identical trees,
> and for-linus-2 merges clean with nfs/nfs-for-3.6.  Would you be OK
> with pulling that one?  Again, my apologies to everyone involved ;-/
> 
> If you are OK with pulling that one, the summary is unchanged, location is
> git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus-2

BTW, Stephen, could you confirm that vfs.git#for-linus-2 has no conflicts
with the rest of trees in linux-next?  I've checked the lack of conflicts
with nfs.git and you haven't mentioned any other conflicts, so I hope
that this will do, but I haven't tried pulling and merging the rest of
the stuff in -next; not with the link I'm behind right now... ;-/
