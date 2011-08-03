Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415Ab1HCTVg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 15:21:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39102 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754778Ab1HCTVc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 15:21:32 -0400
Date: Wed, 3 Aug 2011 21:18:28 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Manuel Lauss <manuel.lauss@googlemail.com>,
        Richard Weinberger <richard@nod.at>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Marc Zyngier <marc.zyngier@arm.com>, linux-kernel@vger.kernel.org
Subject: Re: + shm-fix-a-race-between-shm_exit-and-shm_init.patch added to
	-mm tree
Message-ID: <20110803191828.GA31267@redhat.com>
References: <20110803140456.GA14393@redhat.com> <20110803182417.GA2510@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110803182417.GA2510@albatros>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03, Vasiliy Kulikov wrote:
>
> On Wed, Aug 03, 2011 at 16:04 +0200, Oleg Nesterov wrote:
> >
> > And since we rely on .in_use == 0, why we can't move this check
> > outside of down_write/up_right to a) optimize the code and b)
> > fix the problem?
>
> Agreed.  But I second Linus that partial initialization only hides the
> real problem.  And some initcall chain movement is still needed.

I agree. But, until then, we can make a much more simple fix.
Especially because this patch (imho) mostly hides the problem too.

Oleg.

