Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759275Ab2HHUyb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 16:54:31 -0400
Received: from 1010ds2-suoe.0.fullrate.dk ([90.184.90.115]:17187 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556Ab2HHUya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 16:54:30 -0400
Date: Wed, 8 Aug 2012 22:54:29 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Alexei Kornienko <alexei.kornienko@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: snd_hda_intel bug during boot
In-Reply-To: <alpine.LNX.2.00.1208082243271.10061@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1208082252550.10061@swampdragon.chaosbits.net>
References: <CA+h=+L8geO5kM8VV-+VFkSrvBRJEs31V9OaQ6g98hirRKJWq1g@mail.gmail.com> <alpine.LNX.2.00.1208082243271.10061@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Aug 2012, Jesper Juhl wrote:

> On Wed, 8 Aug 2012, Alexei Kornienko wrote:
> 
> > Seems like I have a bug in audio driver on my laptop. Cause of this I
> > don't have any sound card detected.
> > Please find more details below:
> > 
> > ** Version:
> > Linux version 3.2.0-29-generic-pae (buildd@roseapple) (gcc version
> > 4.6.3 (Ubuntu/Linaro 4.6.3-1ubuntu5) ) #46-Ubuntu SMP Fri Jul 27
> > 17:25:43 UTC 2012
> > 
> Ok, so I openly admit that I have no clue as to what your problem might 
> be. But, one thing I do know is that, a *lot* has changed since the 3.2 
> kernel you are running and the most recent stable (3.5) kernel. So, 
> perhaps you could test the 3.5 kernel and tell us if you still see the 
> problem with that one or not?
> If you are feeling adventurous you could also try a snapshot of the latest 
> Linus (to become 3.6) kernel and tell us your experiences with that...?
> 
Also, if this used to work with an older kernel, then it would probably 
be helpful if you could do a "git bisect" between the older (working) 
kernel version and your current (broken) kernel version in order to zoom 
in on the commit that broke things for you.

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

