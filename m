Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874Ab2BVPJZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 10:09:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50671 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042Ab2BVPJZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 10:09:25 -0500
Message-ID: <4F45050B.4080001@zytor.com>
Date: Wed, 22 Feb 2012 07:08:59 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@redhat.com>,
        a.p.zijlstra@chello.nl, mathieu.desnoyers@efficios.com,
        davem@davemloft.net, ddaney.cavm@gmail.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 00/10] jump label: introduce very_[un]likely + cleanups
 + docs
References: <cover.1329851692.git.jbaron@redhat.com> <4F43F9F0.4000605@zytor.com> <20120221202019.GB2381@redhat.com> <1329856745.25686.72.camel@gandalf.stny.rr.com> <20120222073251.GB17291@elte.hu> <20120222075334.GA25053@elte.hu> <7479958c-1932-4ced-a7a4-53ac6ea3a38e@email.android.com> <20120222081855.GB25318@elte.hu>
In-Reply-To: <20120222081855.GB25318@elte.hu>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2012 12:18 AM, Ingo Molnar wrote:
> 
> For example could you tell *at a glance* what this does:
> 
> +       if (!static_branch_def_false(&perf_sched_events.key))
> 
> ?

Yes.  Unlike

> +       if (very_unlikely(&perf_sched_events.key))

... which is actively misleading.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

