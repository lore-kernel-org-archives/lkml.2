Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757228Ab0ETULZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 16:11:25 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:58381 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754627Ab0ETULY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 16:11:24 -0400
Date: Thu, 20 May 2010 14:11:22 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       akpm@linux-foundation.org
Subject: Re: [RFC PATCH] fuse: support splice() reading from fuse device
Message-ID: <20100520201122.GL10452@parisc-linux.org>
References: <E1OF3kc-00084X-Hi@pomaz-ex.szeredi.hu> <alpine.LFD.2.00.1005201043321.23538@i5.linux-foundation.org> <E1OFAsd-0000Ra-1V@pomaz-ex.szeredi.hu> <alpine.LFD.2.00.1005201215120.23538@i5.linux-foundation.org> <E1OFC1b-0000Yx-80@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1OFC1b-0000Yx-80@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 20, 2010 at 10:07:23PM +0200, Miklos Szeredi wrote:
> > It says nothing at all, in short. You need to have a real source, and a 
> > real destination. Not some empty filesystem and /dev/null destination.
> 
> Sure, I will do that.  It's just a lot harder to measure the effects
> on hardware I have access to, where the CPU speed is just damn too
> large compared to I/O speed.

Try running a CPU burner on all the cores.  Something that's low priority,
so it'll be preempted by FUSE, and doesn't consume much cache.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
