Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751048Ab1DZIMy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 04:12:54 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59278 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756Ab1DZIMw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 04:12:52 -0400
Date: Tue, 26 Apr 2011 10:12:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Chris Samuel <chris@csamuel.org>
Cc: mingo@redhat.com, hpa@zytor.com, thomas@m3y3r.de,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@linux.intel.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86, setup: When probing memory with e801, use
 ax/bx as a pair
Message-ID: <20110426081237.GD806@elte.hu>
References: <1303566747.12067.10.camel@localhost.localdomain>
 <tip-39b68976ac653cfdc7f872a293e8b7928de2dcc6@git.kernel.org>
 <201104261450.15786.chris@csamuel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201104261450.15786.chris@csamuel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Chris Samuel <chris@csamuel.org> wrote:

> On Tue, 26 Apr 2011 09:25:02 AM tip-bot for H. Peter Anvin wrote:
> 
> > x86, setup: When probing memory with e801, use ax/bx as a pair
> 
> ACK. Thanks!

Nice!

Just asking, does the box now boot to user-space, or are there other 
regressions left?

Thanks,

	Ingo
