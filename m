Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755881Ab0J0GCB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 02:02:01 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47463 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668Ab0J0GB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 02:01:59 -0400
Date: Wed, 27 Oct 2010 07:01:56 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] fs: remove inode_lock from iput_final and
 prune_icache
Message-ID: <20101027060156.GG19804@ZenIV.linux.org.uk>
References: <1288153384-8878-1-git-send-email-david@fromorbit.com>
 <1288153384-8878-5-git-send-email-david@fromorbit.com>
 <20101027044038.GE19804@ZenIV.linux.org.uk>
 <1288154866.2652.84.camel@edumazet-laptop>
 <20101027052520.GF19804@ZenIV.linux.org.uk>
 <1288158623.2652.161.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288158623.2652.161.camel@edumazet-laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 27, 2010 at 07:50:23AM +0200, Eric Dumazet wrote:
> Le mercredi 27 octobre 2010 ?? 06:25 +0100, Al Viro a ??crit :
> > "i\xe1\xb9\x89ode_lock", i.e. 'n' turned into U+1E49, aka "latin small letter
> > n with line below".  I doubt that it's MTA braindamage.
> > 
> > In the first patch there's 
> > 
> > - * invalidate_inodes    - attempt to free all inodes on a
> > + * nvalidate_inodes    - attempt to free all inodes on a
> > 
> > and I _really_ doubt that anything in mail system is capable of something
> > that elaborate.
> 
> Again, I can not see it in my copy, I checked lkml archives too :
> 
> http://lkml.org/lkml/2010/10/27/7
> 
> Mail was fine, maybe your file system is corrupted ?

fs corruption inserting pieces like that?  Then we have a serious trouble
of HAL kind...

It's not a result of rediff; it's plain vi /var/mail/$USER...
