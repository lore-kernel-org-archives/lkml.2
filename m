Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522Ab0C2S44 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 14:56:56 -0400
Received: from mail-iw0-f182.google.com ([209.85.223.182]:42593 "EHLO
	mail-iw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312Ab0C2S4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 14:56:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=wZtoiM590syBKEbA4vmaS+hSirU34+NNMyQk0ZAVZjnIGfAF2K+vGV+EPzFh3O9fto
         P/6dP3DbBdm/XLf1AFU4OXgAqEhNk2Nz5QsGYUHXnve+CVOs0kLAgK6HBpfWqIfMJX8u
         0WDSbaj1uz9Za/1OgNJi93/4MJ+G9WcXvK4OM=
Date: Mon, 29 Mar 2010 20:56:54 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: John Kacur <jkacur@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@linux.intel.com>,
       Arnd Bergmann <arnd@arndb.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jan Blunck <jblunck@gmail.com>, Matthew Wilcox <matthew@wil.cx>,
       Oleg Nesterov <oleg@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nvram: Convert nvram_ioctl to unlocked_ioctl, remove
	smp_lock.h
Message-ID: <20100329185652.GH5101@nowhere>
References: <1269866171-7331-2-git-send-email-jkacur@redhat.com> <1383519680.42441269869622199.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383519680.42441269869622199.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 29, 2010 at 09:33:42AM -0400, John Kacur wrote:
> Sorry for the double send, I must have messed-up something with
> git-send-email. The --compose failed on me, and that part of the message was
> lost afaict.
> 
> What I wanted to say was, Ingo, in the past you carried nvram fixes, so
> if no-one objects to this change, can you integrate this one?



Note: Just in case, as I don't know if Ingo or Thomas still maintain
a kill-bkl tree, I keep this patch somewhere so that if it's not merged
in a tree in one week or so, I'll queue it up in mine.

Thanks.

