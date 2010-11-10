Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865Ab0KJSOA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 13:14:00 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54416 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755564Ab0KJSN7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 13:13:59 -0500
Date: Wed, 10 Nov 2010 19:13:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Dan Rosenberg <drosenberg@vsecurity.com>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, kees.cook@canonical.com
Subject: Re: [PATCH v2] Restrict unprivileged access to kernel syslog
Message-ID: <20101110181331.GD22410@elte.hu>
References: <1289348309.7380.31.camel@dan>
 <20101110082516.GB3341@elte.hu>
 <20101110072638.b0e5473d.akpm@linux-foundation.org>
 <20101110175042.GB1923@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101110175042.GB1923@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dave Jones <davej@redhat.com> wrote:

> On Wed, Nov 10, 2010 at 07:26:38AM -0800, Andrew Morton wrote:
>  
>  > a) I'd question the need for the config option.  Are distros really
>  >    so lame that they can't trust themselves to poke a number into
>  >    procfs at boot time?
> 
> short answer: yes.
> 
> * /etc/sysctl.conf is for users to override decisions distros have made,
>   rather than a catalog of those decisions.
> 
> * Sometimes we change our mind on those decisions. Flipping a config option
>   in the kernel means we push out an update, and forget about it.
>   Users /etc/sysctl.conf's contain all kinds of crazyness. ask Davem about
>   the stale TCP 'tuning' crap that lingered for years in Fedora users configs
>   before anyone noticed.
>   (We could update the sysctl.conf at post-install of the kernel package,
>    but if you've ever seen a distro kernel packaging schema, you'd understand
>    why adding more magic like this isn't desirable)
> 
> There's a bunch of patches we carry in Fedora that change defaults because there's 
> no CONFIG option for them, which I've been meaning to get around to hacking up 
> into options so we can carry a few less patches.

_YES_.

A self-contained .config that carries all kernel related defaults is a very powerful 
thing. We need more of that.

Thanks,

	Ingo
