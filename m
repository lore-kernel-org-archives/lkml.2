Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311Ab0CXJuP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 05:50:15 -0400
Received: from cantor.suse.de ([195.135.220.2]:44406 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754326Ab0CXJuN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 05:50:13 -0400
Date: Wed, 24 Mar 2010 20:50:04 +1100
From: Neil Brown <neilb@suse.de>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Two patches for fs/super.c
Message-ID: <20100324205004.34d18940@notabene.brown>
In-Reply-To: <20100324092011.GO30031@ZenIV.linux.org.uk>
References: <20100324051140.10015.32854.stgit@notabene.brown>
	<20100324092011.GO30031@ZenIV.linux.org.uk>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.7; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Mar 2010 09:20:11 +0000
Al Viro <viro@ZenIV.linux.org.uk> wrote:

> On Wed, Mar 24, 2010 at 04:12:23PM +1100, NeilBrown wrote:
> > 
> > Two patches.
> > 
> >  The second removes S_BIAS which is unnecessary and so potentially
> >  confusing.
> > 
> >  The first I found the need for while preparing the second patch.  It
> >  seems that get_active_super doesn't follow the pattern of all other
> >  code that walks the super_blocks list.
> 
> See #untested in vfs tree...
>

Ahhh, I see I've been beaten to it by 2 days... I should have posted that
patch months ago :-)

Thanks anyway.

NeilBrown
