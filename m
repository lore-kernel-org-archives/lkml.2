Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755739Ab0GIKkX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 06:40:23 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43274 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754670Ab0GIKkJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 06:40:09 -0400
Subject: Re: [RFC][PATCH 00/13] perf pmu interface changes -v3
From: Peter Zijlstra <peterz@infradead.org>
To: paulus <paulus@samba.org>
Cc: stephane eranian <eranian@googlemail.com>,
       Robert Richter <robert.richter@amd.com>,
       Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Yanmin <yanmin_zhang@linux.intel.com>,
       Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100709082117.631541128@chello.nl>
References: <20100709082117.631541128@chello.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 09 Jul 2010 12:39:53 +0200
Message-ID: <1278671993.1900.198.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-07-09 at 10:21 +0200, Peter Zijlstra wrote:

Because I'm full of fail today and again had wandering hunks:

> Patches also available in git format for easy testing (tip/master + patches):
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/peterz/linux-2.6-perf.git perf-pmu

The new HEAD should be 6aa2867187
