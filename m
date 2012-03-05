Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232Ab2CEPsg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 10:48:36 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54557 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752981Ab2CEPsf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 10:48:35 -0500
Date: Mon, 5 Mar 2012 16:47:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        dsahern@gmail.com, ravitillo@lbl.gov, khandual@linux.vnet.ibm.com,
        asharma@fb.com, robert.richter@amd.com, ming.m.lin@intel.com,
        vweaver1@eecs.utk.edu, andi@firstfloor.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] perf report: auto-detect branch stack sampling mode
Message-ID: <20120305154753.GA14604@elte.hu>
References: <20120224094048.GA7952@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120224094048.GA7952@quad>
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


Another usability bug of the new branch sampling feature is that 
typing the obvious:

  $ perf record -b ./myprog

does not do the obvious thing and default to 'any' but throws a 
*very* unhelpful generic perf error:

 usage: perf record [<options>] [<command>]
    or: perf record [<options>] -- <command> [<options>]

 ...

Really, we should do better than this. Only people who *want* to 
specify finer LBR filters should be forced to specify them.

Thanks,

	Ingo
