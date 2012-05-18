Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954Ab2ERPZK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 11:25:10 -0400
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:21510 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751730Ab2ERPZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 11:25:08 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: An_M5v0VM1maDYQTv4CptkWXaonmMvhIGRgn0WvMEHrmZH4
 3tNVoDZmF5w7dgj_krN0n8liv7HdKyp5Rfw6nEuNrNdvVS02vlmaXJfy1B4W
 H4.wZp_SfN0ul7Y3XGXov0YhVXvrGTVva4cpeIM9Do9U5CNSnmfsynPm8ibg
 g8AsN89ch3qBZFWYlknFD8bAcJykEANmU8zzGASoLr8gtbl8lymtse7uD1ua
 p_S12C5j41J44.DObpRDDBFLL2EXcmasmqnWD_UEsI3F2PTeAYqX1fTbTu09
 6H09cmWQ6cLzsdqAG9_QiAG5rDfq5QQNzyPk43VdfeD6ruSWnYf1bBikgHX1
 J3ifCApzaz3WdDPyvYi69WBawPcCFYwu8OrLqv.HO0YI3ZrQFGcUhzr5CHAl
 e
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Fri, 18 May 2012 10:25:03 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Rik van Riel <riel@redhat.com>
cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, pjt@google.com,
        bharata.rao@gmail.com, akpm@linux-foundation.org,
        Lee.Schermerhorn@hp.com, aarcange@redhat.com, danms@us.ibm.com,
        suresh.b.siddha@intel.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/numa] sched/numa: Introduce sys_numa_{t,m}bind()
In-Reply-To: <4FB66756.2060302@redhat.com>
Message-ID: <alpine.DEB.2.00.1205181022470.21093@router.home>
References: <tip-nf7brf1b88w0ojwuf689xeet@git.kernel.org> <4FB66756.2060302@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 May 2012, Rik van Riel wrote:

> I like your code for handling smaller processes in NUMA
> systems, but we do need to have a serious discussion on
> how to handle processes that do not fit in one node.

The home node seems to be associated with a thread and not a process. So
we would be able to have multiple home nodes per process.

The whole NUMA policy thing is already quite complex and this will
increase that complexity somewhat. Wish we could simplify things somehow.


