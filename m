Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032629Ab2CSTHJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 15:07:09 -0400
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:36095 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1032553Ab2CSTHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 15:07:07 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 2KaATKIVM1kP_7d6CBwqDWJ3KoMcoTUCF2ZweZblLYjQuKZ
 d4yZgsg4neOYcjm6clMLO1Nk0jqSYIIfpdKu12uDpeDFdKeIGZSh9Fbct8F8
 vbg6FSuHLGX0nJHcMux1kkbqp.FtHiauZDxsrZaLE.QozwAfS2O4XKjRSWsC
 b9DnZp8B2KroSJ_LcKMKZJhqQT.MZaV77KW8UCc3VzAbUUR5MjgRmfF3M_Ix
 yy8ZyIGBHub4h6MXiJbBP5KakZXGJuMQWFGs.VpoVNSnZLlUEbOt9MDgwfr9
 4iLrM89NqFmoLXBTrKrRG_DRHC2YU_xK8Xsk7IFSu.lqoos_X6vL_MqyEwMy
 nGEqgDVaMF7lR_R1dqqonKIoPpHcZlR8TXGYGZHbH2ERoOrsoK9depYMSoD8
 a
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 19 Mar 2012 14:06:49 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Dan Smith <danms@us.ibm.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [RFC][PATCH 10/26] mm, mpol: Make mempolicy home-node aware
In-Reply-To: <1332176969.18960.351.camel@twins>
Message-ID: <alpine.DEB.2.00.1203191406280.23632@router.home>
References: <20120316144028.036474157@chello.nl> <20120316144240.763518310@chello.nl> <alpine.DEB.2.00.1203161333370.10211@router.home> <1331932375.18960.237.camel@twins> <alpine.DEB.2.00.1203190852380.16879@router.home> <1332165959.18960.340.camel@twins>
 <alpine.DEB.2.00.1203191012530.17008@router.home> <1332170628.18960.349.camel@twins> <alpine.DEB.2.00.1203191029090.19189@router.home> <1332176969.18960.351.camel@twins>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Mar 2012, Peter Zijlstra wrote:

> > So the default system behavior would be MPOL_HOME_NODE but it could be
> > overriding by numactl to allow old apps to run as they are used to run.
>
> Ah, OK. Although that's a mightily confusing usage of the word DEFAULT.
> How about instead we make MPOL_LOCAL a real policy and allow explicitly
> setting that?

True. MPOL_LOCAL would be a good choice.

