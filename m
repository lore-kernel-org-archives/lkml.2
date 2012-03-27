Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700Ab2C0NEu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 09:04:50 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:41735 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116Ab2C0NEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 09:04:49 -0400
Date: Tue, 27 Mar 2012 17:03:37 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Alan Cox <alan@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysrq: Use SEND_SIG_FORCED instead of force_sig()
Message-ID: <20120327130337.GA7972@lizard>
References: <20120324110024.GA14067@lizard>
 <20120326154303.86126785.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120326154303.86126785.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2012 at 03:43:03PM -0700, Andrew Morton wrote:
> On Sat, 24 Mar 2012 15:00:24 +0400
[...]
> > > force_sig() can't kill the process if the main thread has already
> > > exited. IOW, it is trivial to create the process which can't be
> > > killed by sysrq.
> > 
> > So, this patch fixes the issue.
[...]
> It's unclear how serious this race is (I'm guessing "not very"), but
> this patch looks like 3.3 material anyway, yes?

Yep, 3.3 looks like a good target.

Thanks,

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
