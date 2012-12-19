Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582Ab2LSQWk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 11:22:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44648 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753703Ab2LSQWc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 11:22:32 -0500
Date: Wed, 19 Dec 2012 17:22:30 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Daniel Berrange <berrange@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: +
	core_pattern-set-core-helpers-root-and-namespace-to-crashing-process
	.patch added to -mm tree
Message-ID: <20121219162230.GA17514@redhat.com>
References: <20121217123428.GA1957@redhat.com> <20121217150559.GD25322@hmsreliant.think-freely.org> <20121217160408.GA20166@redhat.com> <20121217183925.GE25322@hmsreliant.think-freely.org> <20121218200604.GA28834@redhat.com> <20121218201900.GA10059@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121218201900.GA10059@hmsreliant.think-freely.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18, Neil Horman wrote:
>
> On Tue, Dec 18, 2012 at 09:06:04PM +0100, Oleg Nesterov wrote:
> > > Perhaps its best just to restrict this patch to adjusting the root fs location
> > > for the chroot case.
> >
> > Probably... at least for the start.
> >
> > BTW. Of course this is subjective, but personally I think that "||"
> > looks strange. Perhaps it would be better to add something like
> > --croot argument?
> >
> The || is ambiguous with its simmilarity to a shell 'or' command,

Ah, I didn't mean this.

I meant, this is not flexible. We can implement --croot, then we can
(may be) add --switch_ns. If you use "||" now for chroot, what will you
do for switch_ns?

> but I don't
> think the --croot argument is much better on that front, as that then becomes
> ambiguous with arguments supplied to the pipe reader directly.

Not sure I understand... why?

> The token should
> be leading the pipe_reader string in core_pattern to indicate a change in
> environment independent of the executable path.

Do you mean that || at the front is more "visible" ? True, but I am
not sure this is that important.

But I won't insist.

Oleg.

