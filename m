Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757142Ab0ETUWT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 16:22:19 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:50143 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754302Ab0ETUWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 16:22:18 -0400
To: Matthew Wilcox <matthew@wil.cx>
CC: miklos@szeredi.hu, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       akpm@linux-foundation.org
In-reply-to: <20100520201122.GL10452@parisc-linux.org> (message from Matthew
	Wilcox on Thu, 20 May 2010 14:11:22 -0600)
Subject: Re: [RFC PATCH] fuse: support splice() reading from fuse device
References: <E1OF3kc-00084X-Hi@pomaz-ex.szeredi.hu> <alpine.LFD.2.00.1005201043321.23538@i5.linux-foundation.org> <E1OFAsd-0000Ra-1V@pomaz-ex.szeredi.hu> <alpine.LFD.2.00.1005201215120.23538@i5.linux-foundation.org> <E1OFC1b-0000Yx-80@pomaz-ex.szeredi.hu> <20100520201122.GL10452@parisc-linux.org>
Message-Id: <E1OFCFp-0000dB-Es@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 20 May 2010 22:22:05 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 May 2010, Matthew Wilcox wrote:
> On Thu, May 20, 2010 at 10:07:23PM +0200, Miklos Szeredi wrote:
> > > It says nothing at all, in short. You need to have a real source, and a 
> > > real destination. Not some empty filesystem and /dev/null destination.
> > 
> > Sure, I will do that.  It's just a lot harder to measure the effects
> > on hardware I have access to, where the CPU speed is just damn too
> > large compared to I/O speed.
> 
> Try running a CPU burner on all the cores.  Something that's low priority,
> so it'll be preempted by FUSE, and doesn't consume much cache.

Umm, that doesn't really make the CPU any slower, it just makes it
consume more power.

Miklos
