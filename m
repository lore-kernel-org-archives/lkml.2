Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363Ab2CSUnS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 16:43:18 -0400
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:30930 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751541Ab2CSUnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 16:43:16 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 46NkssQVM1mq8oCBSumQ4JqNXT0gIjx4rW.qVUNg2YR6bZj
 Nc2bJdpDFRvdSB8X7rZrOqrXFLKSg_xp0J854bwVU1lYk9mct_JEhqwcLz8t
 EeURYxyAEic7Fai3Xxa4V1Oj7vsAPq8LWBHCL.ucI1rgHojYWddvwifzoOT7
 .tcmERxjvc3V_yNuHeJHDr0JsbQ4wp9AvPxaYy1Lv9xXDmbKTWS45E8gL8i_
 oE9udK.YDGrVO13YbEQsn6SfO0yFYR.IDPnKGS_aFazTvxyrlSKjwcw_usTk
 1hbnhkNDKz3dQ_OGvTlQFT_y5gmc_I.lniHwuGDv.nRDiTJcxFwBAttsOmOu
 G1YOkhrvJvi_d.4B6DfTXbRe95RhFqqxbPThrHDDRTUQn31fZcRbzVYMjLIs
 J
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 19 Mar 2012 15:43:09 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Ingo Molnar <mingo@kernel.org>
cc: Andrea Arcangeli <aarcange@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Avi Kivity <avi@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Dan Smith <danms@us.ibm.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC][PATCH 00/26] sched/numa
In-Reply-To: <20120319202846.GA26555@gmail.com>
Message-ID: <alpine.DEB.2.00.1203191536390.23632@router.home>
References: <20120316144028.036474157@chello.nl> <4F670325.7080700@redhat.com> <1332155527.18960.292.camel@twins> <20120319130401.GI24602@redhat.com> <1332164371.18960.339.camel@twins> <20120319142046.GP24602@redhat.com> <alpine.DEB.2.00.1203191513110.23632@router.home>
 <20120319202846.GA26555@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Mar 2012, Ingo Molnar wrote:

> > I wonder how we can verify that the automatic migration
> > schemes are a real benefit to the application? We have a
> > history of developing a kernel that decreases in performance
> > as development proceeds. How can we make sure that these
> > schemes are actually beneficial overall for all loads and do
> > not cause regressions elsewhere? [...]
>
> The usual way?

Which is merge after a couple of benchmarks and then deal with the
regressions for a couple of years?

Patch verification occurs in an artificial bubble of software run/known by
kernel developers. It can take years before the code is exposed to
real life situations.
