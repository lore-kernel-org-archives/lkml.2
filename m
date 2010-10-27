Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757044Ab0J0GJj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 02:09:39 -0400
Received: from caiajhbdcaid.dreamhost.com ([208.97.132.83]:48668 "EHLO
	homiemail-a4.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751926Ab0J0GJf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 02:09:35 -0400
Subject: Re: [PATCH 4/4] fs: remove inode_lock from iput_final and
 prune_icache
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1288158623.2652.161.camel@edumazet-laptop>
References: <1288153384-8878-1-git-send-email-david@fromorbit.com>
	 <1288153384-8878-5-git-send-email-david@fromorbit.com>
	 <20101027044038.GE19804@ZenIV.linux.org.uk>
	 <1288154866.2652.84.camel@edumazet-laptop>
	 <20101027052520.GF19804@ZenIV.linux.org.uk>
	 <1288158623.2652.161.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Oct 2010 03:09:22 -0300
Message-ID: <1288159762.1985.5.camel@cowboy>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-27 at 07:50 +0200, Eric Dumazet wrote:
> Le mercredi 27 octobre 2010 à 06:25 +0100, Al Viro a écrit :
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
Neither can I, the patch is good (from a character point of view).

