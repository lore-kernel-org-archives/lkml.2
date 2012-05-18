Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757400Ab2ERPsA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 11:48:00 -0400
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:27122 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757328Ab2ERPr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 11:47:57 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: wY2LHesVM1mfetec4m5wIR7X9qCc.cl5TJUJAWwWmBetCZL
 RzZOUzIgxH8PLWWKVFMEQtHPLmpdPZd0E3tBvur2.a.BGdJyyNxn7NOi788P
 D8GqFVAAdaW_9LAuVj6G0bsaG_90bSp8wXjaUW9JBaeGMnkJKsK6TCJs5DvA
 8HHTULUwxIt0qgYALcOvbI0j45hlhpFY0B9dCiZNAMq0iWadOUDGaQSplFQo
 wO6nMvbD7eQLWjTgcEA4uaoo3uto60I9JfdHVHb4Em.OMbAnUykWPZIPUavp
 27slbhbInI0gCjTmenfI6LvTovlRtF9iyOfl.O9Ekcfg7mlX3rkWnOSeI.he
 0B7DkDkdoMxbla3LMFB1H8SK_kGbO7aXos6pm9x_dWjAFG50W02Q4tpzqhET
 r
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Fri, 18 May 2012 10:47:52 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Peter Zijlstra <peterz@infradead.org>
cc: Rik van Riel <riel@redhat.com>, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        pjt@google.com, bharata.rao@gmail.com, akpm@linux-foundation.org,
        Lee.Schermerhorn@hp.com, aarcange@redhat.com, danms@us.ibm.com,
        suresh.b.siddha@intel.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/numa] sched/numa: Introduce sys_numa_{t,m}bind()
In-Reply-To: <1337355610.573.70.camel@twins>
Message-ID: <alpine.DEB.2.00.1205181047030.21093@router.home>
References: <tip-nf7brf1b88w0ojwuf689xeet@git.kernel.org> <4FB66756.2060302@redhat.com> <1337355341.573.68.camel@twins> <1337355610.573.70.camel@twins>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 May 2012, Peter Zijlstra wrote:

> On Fri, 2012-05-18 at 17:35 +0200, Peter Zijlstra wrote:
> > I've also said many times over that I absolutely detest all the async
> > stuff because it messes up accounting. And until someone comes up with a
> > sane means of sorting that I'll stick to migrate-on-fault.
>
> The other nice advantage of migrate-on-fault is that you don't have to
> play lifetime games with vmas. This much simplifies that aspect.

The problem with migrate on fault in the past has been that there was no
consistent benefit from the overhead added to the system. Useless page
migration is a bit expensive.

