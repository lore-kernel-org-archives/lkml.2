Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105Ab1K3N4v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 08:56:51 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:39510 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522Ab1K3N4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 08:56:49 -0500
Date: Wed, 30 Nov 2011 13:56:48 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: what's the replace for the big kernel lock after kernel version
 2.6.39 for system call.
Message-ID: <20111130135648.GW2203@ZenIV.linux.org.uk>
References: <S1752501Ab1KYJXy/20111125092354Z+1871@vger.kernel.org>
 <F0BE05962279964D949D53875492E2E24FC27D7C30@APJ1XCHEVSPIN32.SYMC.SYMANTEC.COM>
 <20111129214136.GR2203@ZenIV.linux.org.uk>
 <201111300944.27607.tvrtko.ursulin@onelan.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201111300944.27607.tvrtko.ursulin@onelan.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 30, 2011 at 09:44:27AM +0000, Tvrtko Ursulin wrote:

> > 1) your rootkit has always been racy; taking BKL does *NOT* prevent another
> > CPU from entering a system call.
> > 
> > 2) none; just don't do it.
> 
> Hi Al,
> 
> Why not be a nice guy when you already took the effort of replying and mention 
> fanotify? Because I am sure you know the history and when you see a security 
> vendor asking these things, you never know, maybe it fits their requirements. 
> Maybe it is not your favourite thing as well, but not a reason not to mention 
> it.

1) I really have not noticed which domain had that come from until after
replying.
2) I have zero sympathy to the author's employer, so even noticing that in
time would not have made the reply any kinder.  Harsher, if nothing else, since
3) said employer was among those who had been told, again and again and again,
that patching syscall table was seriously racy.  Years ago.

> And strictly speaking, rootkits actively try to hide themselves hence whatever 
> unsafe, ugly and wrong stuff they might have it is not a rootkit. :)

Oh?  And how, pray tell, is it _finding_ the syscall table to binary-patch,
if not by rootkit-style methods?  Come to think of that, how does it defeat
the write-protection on said syscall table?

I do stand by my assessment; ignore the domain part of From and Cc and
this question is indistinguishable from "do my homework for me" kind of
question from rootkit-writer.
