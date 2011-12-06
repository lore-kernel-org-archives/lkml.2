Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933037Ab1LFIc2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 03:32:28 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55904 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932984Ab1LFIc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 03:32:27 -0500
Date: Tue, 6 Dec 2011 09:30:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrey Vagin <avagin@openvz.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        linux-perf-users@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        devel@openvz.org, David Ahern <dsahern@gmail.com>,
        Arun Sharma <asharma@fb.com>
Subject: Re: [Devel] [PATCH 0/7] Profiling sleep times (v3)
Message-ID: <20111206083044.GB30062@elte.hu>
References: <1322471015-107825-1-git-send-email-avagin@openvz.org>
 <4EDDC0FB.6080005@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EDDC0FB.6080005@openvz.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
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


* Andrey Vagin <avagin@openvz.org> wrote:

> Hello Arnaldo,
> 
> I found, that you commit patches for perf. Could you review this part?

To help out this effort i have applied your new 
kernel/sched/fair.c event to patch the scheduler
tree (tip:sched/core).

Note, i have renamed it from sched_stat_block to 
sched_stat_blocked - which is really the term we
use for such task states.

Thanks,

	Ingo
