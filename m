Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083Ab0ESHfn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 03:35:43 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54418 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752076Ab0ESHfm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 03:35:42 -0400
Date: Wed, 19 May 2010 09:35:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Lin Ming <ming.m.lin@intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Stephane Eranian <eranian@google.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch 4/4] x86,perf: P4 PMU -- prepare header for user-space
 inclusion
Message-ID: <20100519073509.GF9618@elte.hu>
References: <20100518211916.407689068@openvz.org>
 <20100518212439.542226770@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100518212439.542226770@openvz.org>
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


* Cyrill Gorcunov <gorcunov@openvz.org> wrote:

> The header need to be exported to be able to use P4 PMU 
> in user space applications (for RAW events mostly).

Would be much better to create a pure, separate header 
file with hardware event format details, without all these 
ugly #ifdefs mixed into a single file.

Thanks,

	Ingo
