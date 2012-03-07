Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465Ab2CGGH7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 01:07:59 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45677 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751452Ab2CGGH6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 01:07:58 -0500
Date: Wed, 7 Mar 2012 07:07:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Namhyung Kim <namhyung.kim@lge.com>
Cc: Namhyung Kim <namhyung@gmail.com>, Arun Sharma <asharma@fb.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        dsahern@gmail.com, ravitillo@lbl.gov, khandual@linux.vnet.ibm.com,
        robert.richter@amd.com, ming.m.lin@intel.com, vweaver1@eecs.utk.edu,
        andi@firstfloor.org
Subject: Re: [RFC] perf report: Implement symbol filtering on TUI
Message-ID: <20120307060724.GA4241@elte.hu>
References: <20120306062546.GA622@elte.hu>
 <1331085470-32594-1-git-send-email-namhyung.kim@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331085470-32594-1-git-send-email-namhyung.kim@lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
  0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Namhyung Kim <namhyung.kim@lge.com> wrote:

> As Ingo requested, symbol filtering feature was missing on TUI.
> Add 's' key to get input from user, and do simple filtering by
> strstr(). To turn filtering off, just enter no name by pressing
> 's' followed by ENTER.
> 
> There should be many issues, but I just want to release this
> to get some feedbacks.

I'd love it if in addition to the hotkey, if I typed the obvious 
sequence:

 $ perf report sched

... then it would turn into such a filter automagically.

Thanks,

	Ingo
