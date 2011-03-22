Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756321Ab1CVSPd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 14:15:33 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:50070 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863Ab1CVSPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 14:15:30 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: miklos@szeredi.hu, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        apw@canonical.com, nbd@openwrt.org, neilb@suse.de
In-reply-to: <AANLkTimS-x-+JGvpEbHcWyEMcp-nCno8kwuaBAcTjDnV@mail.gmail.com>
	(message from Linus Torvalds on Tue, 22 Mar 2011 10:30:30 -0700)
Subject: Re: [PATCH 4/6 v7] overlay filesystem prototype
References: <20110322152602.053930811@szeredi.hu> <20110322153018.790784895@szeredi.hu> <AANLkTimS-x-+JGvpEbHcWyEMcp-nCno8kwuaBAcTjDnV@mail.gmail.com>
Message-Id: <E1Q2677-0001H2-86@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 22 Mar 2011 19:15:29 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Mar 2011, Linus Torvalds wrote:
> Just one single C file? Is there no structure to the code at all? No
> separate issues for directory lookup vs file operations, no helper
> libraries vs core ops? No "mount time" vs "runtime" structure to the
> code?
> 
> So 2400 lines isn't all that much, but things have a tendency to grow.
> So when I see one single file that tries to do everything, I go "hmm".
> Normal filesystems tend to have super.c for handling the mount itself,
> and dir.c vs file.c for directory ops vs file ops. Maybe this doesn't
> have a file.c because that's all delegated to the lower filesystems,
> but still.. Just one file?
> 
> Yeah, yeah, we have those horrible drivers that have 10k+ files, and
> there are certainly filesystems with much bigger files, but I'd still
> wish for more structure.  You've got a whole subdirectory of your own.

Sure, good comment.

I'll split this for the actual pull request, if the overall approach
gets an ACK.

Thanks,
Miklos
