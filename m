Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566Ab1K3OMR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 09:12:17 -0500
Received: from claranet-outbound-smtp06.uk.clara.net ([195.8.89.39]:34695 "EHLO
	claranet-outbound-smtp06.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755443Ab1K3OMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 09:12:16 -0500
From: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
To: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: what's the replace for the big kernel lock after kernel version 2.6.39 for system call.
Date: Wed, 30 Nov 2011 14:12:13 +0000
User-Agent: KMail/1.13.7 (Linux/3.1.0-1.fc15.x86_64; KDE/4.6.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <S1752501Ab1KYJXy/20111125092354Z+1871@vger.kernel.org> <201111300944.27607.tvrtko.ursulin@onelan.co.uk> <20111130135648.GW2203@ZenIV.linux.org.uk>
In-Reply-To: <20111130135648.GW2203@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111301412.13160.tvrtko.ursulin@onelan.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 Nov 2011 13:56:48 Al Viro wrote:
> On Wed, Nov 30, 2011 at 09:44:27AM +0000, Tvrtko Ursulin wrote:
> > > 1) your rootkit has always been racy; taking BKL does *NOT* prevent
> > > another CPU from entering a system call.
> > > 
> > > 2) none; just don't do it.
> > 
> > Hi Al,
> > 
> > Why not be a nice guy when you already took the effort of replying and
> > mention fanotify? Because I am sure you know the history and when you
> > see a security vendor asking these things, you never know, maybe it fits
> > their requirements. Maybe it is not your favourite thing as well, but
> > not a reason not to mention it.
> 
> 1) I really have not noticed which domain had that come from until after
> replying.
> 2) I have zero sympathy to the author's employer, so even noticing that in
> time would not have made the reply any kinder.  Harsher, if nothing else,
> since 3) said employer was among those who had been told, again and again
> and again, that patching syscall table was seriously racy.  Years ago.

I then hope if you had spotted the senders domain you would have mentioned 
fanotify, even after flaming them to your hearts content.

> > And strictly speaking, rootkits actively try to hide themselves hence
> > whatever unsafe, ugly and wrong stuff they might have it is not a
> > rootkit. :)
> 
> Oh?  And how, pray tell, is it _finding_ the syscall table to binary-patch,
> if not by rootkit-style methods?  Come to think of that, how does it defeat
> the write-protection on said syscall table?
> 
> I do stand by my assessment; ignore the domain part of From and Cc and
> this question is indistinguishable from "do my homework for me" kind of
> question from rootkit-writer.

I just said, and that with a casual modifier, that it is not a rootkit _by 
definition_ of a rootkit so please don't read more from it than it was.

Tvrtko
