Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758116Ab2ERQHx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 12:07:53 -0400
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:43570 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757808Ab2ERQHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 12:07:51 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: nO68lC4VM1kvuSLF8umO_iW_jg5cEBwHNXEGhuDFlIIqJOJ
 JPGC2_z9x6qf2W8CgPKzTxbkH6juDKRdtNb2Oyyq3wkyDCFReE24auslx9T3
 hthIK_ltRYuz1Eyb1ieks42qQHs1jRFoQPoETAQMz7BYP_upfQ50wF4iVbiL
 rUxnFBsoDdr42SBizeR2hrUyslczCk_q6UDdR.Ba.q3iJVmMtJpZYd3oIi5M
 1PLDJglatS2pvlZPhNzdByPbSNDmg5DmRaNLBjYIAMbsI_V5JL0jWsSobbls
 qT.4hqg7zjYULYUvp0b5aPY1v399WiEH9QlAmxAOvDGwS4R8u.jklQDoJ8Me
 GPbjMg5JgzPSJPDM1XfHsIO0ByM9r5YTsHQEcP3hxnxoXW_Y5q9foeu6HP.M
 Q.9WAwtnNix0VsxTuWVr4zSeCO_GefCz_0mkS
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Fri, 18 May 2012 11:07:45 -0500 (CDT)
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
In-Reply-To: <1337357041.573.86.camel@twins>
Message-ID: <alpine.DEB.2.00.1205181107090.21093@router.home>
References: <tip-nf7brf1b88w0ojwuf689xeet@git.kernel.org> <4FB66756.2060302@redhat.com> <1337355341.573.68.camel@twins> <1337355610.573.70.camel@twins> <alpine.DEB.2.00.1205181047030.21093@router.home> <1337356192.573.75.camel@twins>
 <alpine.DEB.2.00.1205181057400.21093@router.home> <1337357041.573.86.camel@twins>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 May 2012, Peter Zijlstra wrote:

> On Fri, 2012-05-18 at 11:00 -0500, Christoph Lameter wrote:
>
> > Having the page local is a win if there are a sufficient number of
> > accesses to amortize the effort to move the page. Given the expensive
> > nature of page migration there would need to be a large number of accesses
> > to a page to justify the effort.
>
> Right, but this is true of any migration scheme and not specific to MoF.

Yes and the concern about auto migration schemes not improving performance
in general applies to all migration schemes.
