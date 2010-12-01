Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340Ab0LAKSI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 05:18:08 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44384 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750965Ab0LAKSG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 05:18:06 -0500
Date: Wed, 1 Dec 2010 11:17:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: autogroup patches for mainline 2.6.37-rc4 and stable 2.6.36.1
Message-ID: <20101201101752.GA23008@elte.hu>
References: <1291193567.3882.23.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291193567.3882.23.camel@marge.simson.net>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.3 required=5.9 tests=BAYES_00,FUZZY_VPILL autolearn=no SpamAssassin version=3.2.5
	0.7 FUZZY_VPILL            BODY: Attempt to obfuscate words in spam
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Galbraith <efault@gmx.de> wrote:

> Greetings,
> 
> For those interested in trying out 'autogroup', please find patches for
> $subject attached.  The 2.6.36.1 patch depends upon the (also attached)
> cgroup movement fixup patch already in mainline.
> 
> Bug reports welcome.  I'll likely be a bit slow responding, as I have a
> backlog to slog through, but rest assured, they'll not go to waste.

The autogroup scheduling feature is now also available via the scheduler development 
tree, 2.6.37-rc4 based, via:

   http://people.redhat.com/mingo/tip.git/README

And the feature has been queued up for a v2.6.38 merge. Testing so far is promising 
- beyond testboxes i run it on one of my main boxes as well and have noticed no 
troubles.

Thanks,

	Ingo
