Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731Ab2BQOxz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 09:53:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26878 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751389Ab2BQOxy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 09:53:54 -0500
Date: Fri, 17 Feb 2012 15:46:59 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, apw@canonical.com,
        arjan@linux.intel.com, fhrbata@redhat.com, john.johansen@canonical.com,
        penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com,
        rusty@rustcorp.com.au, tj@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] make vfork() killable
Message-ID: <20120217144659.GC22440@redhat.com>
References: <20120214164709.GA21178@redhat.com> <20120214164914.GF21185@redhat.com> <20120215123049.6e938eed.akpm@linux-foundation.org> <20120216150429.GB11953@redhat.com> <20120216172626.GA30393@redhat.com> <20120216162602.386cadf9.akpm@linux-foundation.org> <20120217134537.d1ad20de8b048916fbd4eb0a@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120217134537.d1ad20de8b048916fbd4eb0a@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On 02/17, Stephen Rothwell wrote:
>
> On Thu, 16 Feb 2012 16:26:02 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > hum.  Via which tree did they get into linux-next and why did they not
> > get any further?
>
> They were in the ptrace tree from Aug 26 last year ... they were still
> there on Oct 14 and then the ptrace tree was removed ("temporarily", at
> Oleg's request) from linux-next on Oct 24.

Yes, thanks Stephen.

And yes, it was "temporarily" because I hoped to restore my korg account
quickly. But it is not that easy ;)

Oleg.

