Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667Ab1BXQ5R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 11:57:17 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41336 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752617Ab1BXQ5Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 11:57:16 -0500
Date: Thu, 24 Feb 2011 17:57:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] perf: x86, add SandyBridge support
Message-ID: <20110224165705.GA15498@elte.hu>
References: <1298555968.2220.15.camel@localhost>
 <1298556237.2220.19.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298556237.2220.19.camel@localhost>
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


* Lin Ming <ming.m.lin@intel.com> wrote:

> Adds SandyBridge support to perf.

Wondering, have you tested things like PEBS? You can do it via:

	perf record -e instructions:p -a sleep 10
	perf top -e instructions:p

('p' stands for 'precise')

Also, please list known limitations in the changelog.

Thanks,

	Ingo
