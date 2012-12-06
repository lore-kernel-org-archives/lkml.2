Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621Ab2LFNU4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 08:20:56 -0500
Received: from tundra.namei.org ([65.99.196.166]:51318 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752093Ab2LFNUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 08:20:54 -0500
Date: Fri, 7 Dec 2012 00:25:48 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Casey Schaufler <casey@schaufler-ca.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: linux-next: unusual update of the security tree
In-Reply-To: <20121128110132.0082c87680b9b714b8c0689c@canb.auug.org.au>
Message-ID: <alpine.LRH.2.02.1212070024460.4693@tundra.namei.org>
References: <20121128101635.d5e864dffc4252ef9d5e1664@canb.auug.org.au> <50B5508D.7050409@schaufler-ca.com> <20121128110132.0082c87680b9b714b8c0689c@canb.auug.org.au>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any suggestions on how to fix this?  That branch is public, and what 
people use to develop against, so I can't rebase it.



On Wed, 28 Nov 2012, Stephen Rothwell wrote:

> Hi Casey,
> 
> On Tue, 27 Nov 2012 15:45:17 -0800 Casey Schaufler <casey@schaufler-ca.com> wrote:
> >
> > On 11/27/2012 3:16 PM, Stephen Rothwell wrote:
> > 
> > > The security tree
> > > (git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git#next)
> > > looks a bit strange today ... It appears to have been created by Casey
> > > Schaufler (cc'd) and contains some quite old commits and back merges of
> > > your tree.  I *guess* you have merged in Casey's tree after he merged in
> > > your tree from yesterday.
> > 
> > I *thought* that I had used the same procedures that worked before.
> > In fact, I still do think that, but if it's a problem I can purge my
> > smack-next tree and start over.
> > 
> > James, the two changes that came from smack-next are pretty minor. I
> > don't think you should hesitate to back them out if that helps.
> 
> This is the shortlog for the changes in the security tree between
> yesterday and today;
> 
> Casey Schaufler (32):
>       Commit 272cd7a8c67dd40a31ecff76a503bbb84707f757 introduced     a change to the way rule lists are handled and reported in     the smackfs filesystem. One of the issues addressed had to     do with the termination of read requests on /smack/load.     This change introduced a error in /smack/cipso, which shares     some of the same list processing code.
>       Revert "Commit 272cd7a8c67dd40a31ecff76a503bbb84707f757 introduced"
>       Smack: smackfs cipso seq read repair
>       Merge branch 'next' of git://git.kernel.org/.../jmorris/linux-security
>       Merge branch 'next' of git://git.kernel.org/.../jmorris/linux-security
>       Smack: recursive tramsmute
>       Merge branch 'next' of git://git.kernel.org/.../jmorris/linux-security
>       Merge branch 'next' of git://git.kernel.org/.../jmorris/linux-security
>       Merge branch 'next' of git://git.kernel.org/.../jmorris/linux-security
>       Merge branch 'next' of git://git.kernel.org/.../jmorris/linux-security
>       Smack: allow for significantly longer Smack labels v4
>       Merge branch 'next' of git://git.kernel.org/.../jmorris/linux-security
>       Smack: fix smack_new_inode bogosities
>       Smack: Maintainer Record
>       Smack: onlycap limits on CAP_MAC_ADMIN
>       Merge branch 'next' of git://git.kernel.org/.../jmorris/linux-security
>       Merge branch 'next' of git://git.kernel.org/.../jmorris/linux-security
>       Smack: user access check bounds
>       Merge branch 'next' of git://git.kernel.org/.../jmorris/linux-security
>       Merge branch 'next' of git://git.kernel.org/.../jmorris/linux-security
>       Smack: remove task_wait() hook.
>       Smack: setprocattr memory leak fix
>       Merge branch 'next' of git://git.kernel.org/.../jmorris/linux-security
>       Merge branch 'next' of git://git.kernel.org/.../jmorris/linux-security
>       Merge branch 'next' of git://git.kernel.org/.../jmorris/linux-security
>       Merge branch 'for-1209'
>       Merge branch 'next' of git://git.kernel.org/.../jmorris/linux-security
>       Merge branch 'next' of git://git.kernel.org/.../jmorris/linux-security
>       Merge branch 'next' of git://git.kernel.org/.../jmorris/linux-security
>       Merge branch 'next' of git://git.kernel.org/.../jmorris/linux-security into for-1211
>       Smack: use select not depends in Kconfig
>       Smack: create a sysfs mount point for smackfs
> 
> Rafal Krypa (2):
>       Smack: don't show empty rules when /smack/load or /smack/load2 is read
>       Smack: implement revoking all rules for a subject label
> 
> Tetsuo Handa (1):
>       gfp flags for security_inode_alloc()?
> 
> It's a bit of a mess :-(
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 

-- 
James Morris
<jmorris@namei.org>
