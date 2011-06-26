Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357Ab1FZVL2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 17:11:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18066 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753779Ab1FZVKb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 17:10:31 -0400
Date: Sun, 26 Jun 2011 23:08:23 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, vda.linux@googlemail.com,
        jan.kratochvil@redhat.com, pedro@codesourcery.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] ptrace: ptrace_reparented() should check
	same_thread_group()
Message-ID: <20110626210823.GC16293@redhat.com>
References: <20110624153330.GA9346@redhat.com> <20110624153406.GB9346@redhat.com> <20110625134350.GU30101@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110625134350.GU30101@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25, Tejun Heo wrote:
>
> This patch involves very subtle behavior change when the tracer is
> multi-threaded && real parent of the tracee.  Slightly worrisome

Agreed. That is why, despite the fact the change itself is trivial,
the changelog is so long.

I am almost sure nobody will ever notice this change, but still this
is the user-visible change.

> but
> it is a bug fix and extremely fringe, so...

Agreed. Even if very minor, this looks like a bug, imho makes sense
to fix.

>  Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

Oleg.

