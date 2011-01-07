Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207Ab1AGVB6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 16:01:58 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:55302 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677Ab1AGVB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 16:01:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=WvQJouAFxvuC4B6RQ0MFzGsr9BijP//mecAfaf/ceXUESr5E9q5+ciI5hf3dAHFDGB
         ++x2skFGoBQYxrrUaITYNn+Dh3KzU7itlJ6UOnT58mI/aKeikG+hUCEIpg6SrIl384Ds
         QYNYhGZExAu15Xpi56iBAr/Vj0JkFL3QktCF8=
Date: Fri, 7 Jan 2011 16:01:52 -0500
From: Tejun Heo <tj@kernel.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Nick Piggin <npiggin@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, Yong Zhang <yong.zhang0@gmail.com>,
        linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        Linux-Arch <linux-arch@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>
Subject: Re: [RFC][PATCH] spinlock: Kill spin_unlock_wait()
Message-ID: <20110107210152.GG7355@mtj.dyndns.org>
References: <20101224122338.172750730@chello.nl>
 <20101224123742.724459093@chello.nl>
 <AANLkTikGBsh0-QTe9CA2gwDtwzpdMi+fbDsTEKiJAL0P@mail.gmail.com>
 <1294054362.2016.74.camel@laptop>
 <20110104064542.GF3402@amd>
 <1294254867.2016.281.camel@laptop>
 <AANLkTi=URmD1GYqp+PfVf6rc0tXvRnAQG808LMnBRgG1@mail.gmail.com>
 <1294306353.2016.304.camel@laptop>
 <20110106103841.GA3493@amd>
 <1294338395.2016.381.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294338395.2016.381.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Jan 06, 2011 at 07:26:35PM +0100, Peter Zijlstra wrote:
> Jeff, Tejun, could you look at the ata-eh thing, then I'll put sorting
> through the futex thing on my todo list.

Hmm... I think the ->eng_timeout path is already dead.  We no longer
have any in-kernel implementation, so killing spin_unlock_wait()
should be fine.  I'll follow up with removal of the unused callback.

Thanks.

-- 
tejun
