Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863Ab0LZWMy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Dec 2010 17:12:54 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:19723 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377Ab0LZWMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Dec 2010 17:12:53 -0500
Date: Sun, 26 Dec 2010 23:03:15 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Tsozik <tsozik@yahoo.com>
cc: Randy Dunlap <rdunlap@xenotime.net>, Greg KH <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] mct_u232: IOCTL implementation
In-Reply-To: <489629.5504.qm@web65703.mail.ac4.yahoo.com>
Message-ID: <alpine.LNX.2.00.1012262255080.20797@swampdragon.chaosbits.net>
References: <489629.5504.qm@web65703.mail.ac4.yahoo.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Dec 2010, Tsozik wrote:

> Randy,
> 
> Greg referred to git as to place where change log comments are now 
> checked in. I googled it and found that one can also check out latest 
> kernel source code as opposed to tarball download. However, You're 
> right, looking at 
> http://kernelnewbies.org/UpstreamMerge/SubmittingPatches documentation I 
> don't see how one can use git to check in comments or code directly to 
> git repository,
> 

Only Linus can check code into the final official tree. But, you can use 
git to get a copy of the latest Linus tree (and many other trees run by 
various maintainers and others). Git is also useful for maintaining your 
own local branch with your changes.

The way it usually works is that you create a patch and send it off to 
some sub-system maintainer via email patch ('git diff' generated usually) 
or via email pull request for your personal repository. The sub-system 
maintainer then merges your patch with his tree and, at a later date, 
submits his tree (including your patch) to Linus.

Changelog comments are tracked with git. Once your patch is accepted it 
will eventually make its way to Linus' tree and your changelog comments in 
the patch mail (or git commit message - if you send a pull request) will 
eventually turn into a git commit message in the official tree. So there's 
no need to add changelog info in the files themselves.
Check http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=shortlog 
(or git log after cloning the tree) to see commit messages.


-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

