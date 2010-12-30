Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523Ab0L3JEm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 04:04:42 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34793 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753177Ab0L3JEk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 04:04:40 -0500
Date: Thu, 30 Dec 2010 10:04:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>,
        "David S. Miller" <davem@davemloft.net>, Jens Axboe <axboe@kernel.dk>,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/8] init: rename CONFIG_EMBEDDED to CONFIG_EXPERT
Message-ID: <20101230090423.GA7306@elte.hu>
References: <alpine.DEB.2.00.1012291959200.27241@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1012291959200.27241@chino.kir.corp.google.com>
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


* David Rientjes <rientjes@google.com> wrote:

> The meaning of CONFIG_EMBEDDED has long since been obsoleted; the option
> is used to configure any non-standard kernel with a much larger scope
> than only small devices.
> 
> This patch renames the option to CONFIG_EXPERT in init/Kconfig and fixes
> references to the option in the same file.  Followup patches will fix the
> remainder of the occurrences in the tree.
> 
> Calling the option "EXPERT" more accurately represents its intention:
> only expert users who understand the impact of the configuration changes
> they are making should enable it.
> 
> Signed-off-by: David Rientjes <rientjes@google.com>

Nice! For all patches:

Reviewed-by: Ingo Molnar <mingo@elte.hu>

	Ingo
