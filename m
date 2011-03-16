Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393Ab1CPR4f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 13:56:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39007 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751218Ab1CPR43 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 13:56:29 -0400
MIME-Version: 1.0
In-Reply-To: <smp-call-function-intro-v3@mdm.bga.com>
References: <20110112150740.77dde58c@kryten> <1295288253.30950.280.camel@laptop>
 <smp-call-function-peter-reply@mdm.bga.com> <smp-call-function-move-writes@mdm.bga.com>
 <1296145360.15234.234.camel@laptop> <smp-call-function-list-race@mdm.bga.com>
 <smp-call-function-list-race-fix@mdm.bga.com> <ipi-list-reply@mdm.bga.com>
 <smp-cfm-list-comment@mdm.bga.com> <smp-call-function-list-race-fix-v2@mdm.bga.com>
 <20110201220026.GD2142@linux.vnet.ibm.com> <ipi-paul-reply@mdm.bga.com>
 <20110202041740.GB2129@linux.vnet.ibm.com> <20110206235136.GA23658@linux.vnet.ibm.com>
 <smp-call-function-intro-v3@mdm.bga.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 16 Mar 2011 10:55:39 -0700
Message-ID: <AANLkTikzOUHZzkHhw3j0r19=kT=cgcw4F3d7SEanwuui@mail.gmail.com>
Subject: Re: [PATCH 0/4 v3] smp_call_function_many issues from review
To: Milton Miller <miltonm@bga.com>
Cc: Peter Zijlstra <peterz@infradead.org>, akpm@linux-foundation.org,
        Anton Blanchard <anton@samba.org>, xiaoguangrong@cn.fujitsu.com,
        mingo@elte.hu, jaxboe@fusionio.com, npiggin@gmail.com,
        rusty@rustcorp.com.au, efault@gmx.de,
        Jan Beulich <JBeulich@novell.com>, Dimitri Sivanich <sivanich@sgi.com>,
        Tony Luck <tony.luck@intel.com>, paulmck@linux.vnet.ibm.com,
        benh@kernel.crashing.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 15, 2011 at 12:27 PM, Milton Miller <miltonm@bga.com> wrote:
>
> Looking forward, I would suggest 1 and 2 are required for stable, 3 may
> be suitable as it fixes races that otherwise requires cpumask copies
> as in 75c1c91cb92806f960fcd6e53d2a0c21f343081c ([IA64] eliminate race
> condition in smp_flush_tlb_mm).  By contrast 4 is just comments except
> for the %pS to %pf change.

Ok, who should I expect to take this series from? I think the last
batch came through Andrew. The kernel/smp.c file seems to be one of
those "unclear maintenance rules" one. The git statistics for the last
12 months seem to be

  Andrew Morton <akpm@linux-foundation.org> (commit_signer:4/9=44%)
  Peter Zijlstra <peterz@infradead.org> (commit_signer:2/9=22%)
  Milton Miller <miltonm@bga.com> (commit_signer:2/9=22%)
  Tejun Heo <tj@kernel.org> (commit_signer:2/9=22%)
  Ingo Molnar <mingo@elte.hu> (commit_signer:2/9=22%)

according to get_maintainer.pl. Should I just take these directly?

                      Linus
