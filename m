Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743Ab1B1HzL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 02:55:11 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58969 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751179Ab1B1HzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 02:55:10 -0500
Date: Mon, 28 Feb 2011 08:54:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Renninger <trenn@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: lenb@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Several riskless, tiny fixes
Message-ID: <20110228075459.GA1600@elte.hu>
References: <1298842606-55712-1-git-send-email-trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298842606-55712-1-git-send-email-trenn@suse.de>
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


* Thomas Renninger <trenn@suse.de> wrote:

> Some of these could still get pushed into 2.6.38?
> 
> If not, it would be great if they get queued in:
>  - x86-tip tree, the two perf patches and the pm_qos patch

I suspect the pm_qos patch should be processed by the PM tree - Rafael?

Thanks,

	Ingo
