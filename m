Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665Ab1FIB7x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 21:59:53 -0400
Received: from cantor.suse.de ([195.135.220.2]:55861 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752454Ab1FIB7u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 21:59:50 -0400
Date: Thu, 9 Jun 2011 11:59:34 +1000
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, viro@ZenIV.linux.org.uk,
        torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, apw@canonical.com, nbd@openwrt.org,
        hramrach@centrum.cz, jordipujolp@gmail.com, ezk@fsl.cs.sunysb.edu,
        mszeredi@suse.cz
Subject: Re: [PATCH 0/7] overlay filesystem: request for inclusion
Message-ID: <20110609115934.3c53f78f@notabene.brown>
In-Reply-To: <20110608153208.dc705cda.akpm@linux-foundation.org>
References: <1306932380-10280-1-git-send-email-miklos@szeredi.hu>
	<20110608153208.dc705cda.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Jun 2011 15:32:08 -0700 Andrew Morton <akpm@linux-foundation.org>
wrote:

> On Wed,  1 Jun 2011 14:46:13 +0200
> Miklos Szeredi <miklos@szeredi.hu> wrote:
> 
> > I'd like to ask for overlayfs to be merged into 3.1.
> 
> Dumb questions:
> 
> I've never really understood the need for fs overlaying.  Who wants it?
> What are the use-cases?

https://lwn.net/Articles/324291/

I think the strongest use case is that LIVE-DVD's want it to have a write-able
root filesystem which is stored on the DVD.

> 
> This sort of thing could be implemented in userspace and wired up via
> fuse, I assume.  Has that been attempted and why is it inadequate?

I think that would be a valid question if the proposal was large and
complex.  But overlayfs is really quite small and self-contained.

NeilBrown
