Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493Ab0DXPZi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Apr 2010 11:25:38 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39015 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753391Ab0DXPZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Apr 2010 11:25:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RCbvHguUcjER6l1mrduJkZ3EdsmD6tJaWmhO0p/y7gRVtgdplXlREo9XOpgHwx/3L0
         9y/Bzg4/sirFhqgqFxE2tSBzVV4JPANx0T4fE+QBmWokytsRaUIknkOhicmYPgRkJ+FR
         TqzHNEAMNXdQCvfKUecMl3KEa5HwkFBRWZmvA=
Date: Sat, 24 Apr 2010 17:25:44 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
       Thomas Gleixner <tglx@linutronix.de>, Al Viro <viro@ZenIV.linux.org.uk>,
       Jan Blunck <jblunck@suse.de>, Ingo Molnar <mingo@elte.hu>,
       John Kacur <jkacur@redhat.com>
Subject: Re: [GIT PULL v2] Preparation for BKL'ed ioctl removal
Message-ID: <20100424152542.GD5545@nowhere>
References: <1271390201-20431-1-git-send-regression-fweisbec@gmail.com> <1271897282-11207-1-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271897282-11207-1-git-send-regression-fweisbec@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 22, 2010 at 02:48:02AM +0200, Frederic Weisbecker wrote:
> Linus,
> 
> In this v2, I've removed the declaration of default_llseek
> from smp_lock.h, as this export can be made later (we
> want to make any use of default_llseek() depend on
> CONFIG_BKL as well, but that can wait).
> 
> Please pull the bkl/ioctl-v2 branch that can be found at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> 	bkl/ioctl-v2
> 
> Thanks,
> 	Frederic



Hi Linus,

This is the second version of this pull request and you don't seem to be
pulling it either.

Could you please tell us what kind of hesitation or problems you may have
with this?

If you think it's too late to merge this, we can still cook it for 2.6.35
and apply every dependent ioctl conversion in the same tree, this will have
the drawback that we can't push dependent patches to the relevant maintainers
trees (that said I guess that a good part of the drivers that still implement ioctl
are about unmaintained areas).

Or may be you don't like the core idea of this patch.

Either way please tell us so that we can go ahead with this and choose a
direction that looks more appropriate for you.

Thanks,
	Frederic.

