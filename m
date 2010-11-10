Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755759Ab0KJSKK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 13:10:10 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48351 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755265Ab0KJSKH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 13:10:07 -0500
Date: Wed, 10 Nov 2010 19:10:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Rosenberg <drosenberg@vsecurity.com>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, kees.cook@canonical.com
Subject: Re: [PATCH v2] Restrict unprivileged access to kernel syslog
Message-ID: <20101110181000.GC22410@elte.hu>
References: <1289348309.7380.31.camel@dan>
 <20101110082516.GB3341@elte.hu>
 <20101110072638.b0e5473d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101110072638.b0e5473d.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> OK by me, apart from ...
> 
> a) I'd question the need for the config option.  Are distros really
>    so lame that they can't trust themselves to poke a number into
>    procfs at boot time?

When it comes to security i personally prefer 'permanent' defaults that is a 
property of the booting image. I'd even change the default for the x86 defconfig for 
example - and we could make this option default-y in the future. (We cannot ever 
make the sysctl default itself default-1, it would break compatibility with old 
behavior.)

> b) we have "dmesg_restrict" and "CONFIG_RESTRICT_DMESG".  Less
>    dyslexia, please.

Good point. CONFIG_DMESG_RESTRICT is the proper hierarchical naming i suspect.

Thanks,

	Ingo
