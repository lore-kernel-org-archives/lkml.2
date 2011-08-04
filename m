Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862Ab1HDXLs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 19:11:48 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:57309 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381Ab1HDXLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 19:11:42 -0400
Date: Fri, 5 Aug 2011 00:11:34 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        apw@canonical.com, nbd@openwrt.org, neilb@suse.de, hramrach@centrum.cz,
        jordipujolp@gmail.com, ezk@fsl.cs.sunysb.edu, ricwheeler@gmail.com,
        dhowells@redhat.com, hpj@urpla.net, sedat.dilek@googlemail.com,
        penberg@kernel.org, mszeredi@suse.cz
Subject: Re: [PATCH 0/8] overlay filesystem: request for inclusion
Message-ID: <20110804231134.GO2203@ZenIV.linux.org.uk>
References: <1312462417-8826-1-git-send-email-miklos@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312462417-8826-1-git-send-email-miklos@szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 04, 2011 at 02:53:29PM +0200, Miklos Szeredi wrote:
> Al, Linus and all interested parties,
> 
> Here's the latest version of overlayfs.
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs.v11
> 
> I think it's been merge-ready for some time and has gotten a fair
> amount of attention and testing from various parties.  Yet,
> apparently, it isn't getting closer to being merged.
> 
> There's union-mounts which has a very similar feature set, if a
> completely different implementation, but that also is not being
> considered yet for merge.
> 
> So, Al, can you please share your thougths?

Simple: please, *please* hold back until we have atomic_open mess sorted
out.  I'm fucking sick and tired of playing whack-a-mole in that area -
for nearly three years by now; we fortunately are very close to getting
this shit done right - the main remaining obstacle is ->d_revalidate()
abuse by NFS and I seriously hope to get it over and done with in a week or so.
Once that is done and the damn thing is in #for-next, I'll ping you, dhowells
and probably aufs folks to start sorting this out, so that we would have that
finished before 3.2 opens.
