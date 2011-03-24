Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933772Ab1CXIsd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 04:48:33 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33411 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932655Ab1CXIsb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 04:48:31 -0400
Date: Thu, 24 Mar 2011 09:48:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Lin Ming <ming.m.lin@intel.com>, Don Zickus <dzickus@redhat.com>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] perf, x86: P4 PMU - Add missing read of a counter
 before test
Message-ID: <20110324084819.GH30812@elte.hu>
References: <AANLkTikwJFCrpTit8=-=agowkTwZtoyEtFaE7yp0O8MF@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikwJFCrpTit8=-=agowkTwZtoyEtFaE7yp0O8MF@mail.gmail.com>
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


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> Don, I've added yours SOB, ok? (The patch is attached to avoid
> space/tabs problem
> due to web-mail client)

The patch lacks a proper description about the motivation and effects of the 
patch.

Thanks,

	Ingo
