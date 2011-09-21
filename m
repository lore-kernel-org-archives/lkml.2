Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722Ab1IUP7T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 11:59:19 -0400
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:37409 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750783Ab1IUP7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 11:59:18 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: BVhC26UVM1nmclfmNnjxWsHCIwsxUotXL_NBgZftgYa5OIz
 mJfzCwNXSiow0RxMTYZbHG2oRaUM1cJJGgZW9SVM5zHCpiEZnTfJ.oeChdTX
 YEUIvmDpwmIuedgtd1Abk2g5II88mnHhgQsqpjnxAsoIaI7rPO5KELeNOIom
 v.Qp10zBPDizePDPJer6c31ScrHxdq7HpkLiJj_CfRP.IBxdLTWIhUiw3arM
 msFCNZN6m9tnL.6mIw6bpu0H3yorcPPqP8.DALEgFM1o19JoBk7rkjTpMoOw
 IPIZyVIUr6wT3WPpSmRcrf_DGI4DonWv7f36L_3n0Qgr5B0ayySleOl3Ee9s
 yh9LM7LVLByuYf4VJHeGm1eiy0V7nhCB9H1J0zLshSJevEZ.irzFhHmtHeci
 89Dp_z10dnYYPQzZLYIoL46c-
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 21 Sep 2011 10:59:12 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
X-X-Sender: cl@router.home
To: Steven Rostedt <rostedt@goodmis.org>
cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC][PATCH 0/5] Introduce checks for preemptable code for
 this_cpu_read/write()
In-Reply-To: <1316619103.29966.139.camel@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.2.00.1109211046350.14676@router.home>
References: <20110919212040.745370781@goodmis.org>  <alpine.DEB.2.00.1109191644190.19059@router.home>  <1316487977.29966.32.camel@gandalf.stny.rr.com>  <20110920154610.GB28952@Krystal>  <1316534441.29966.79.camel@gandalf.stny.rr.com> 
 <alpine.DEB.2.00.1109201109470.8056@router.home>  <1316544841.29966.121.camel@gandalf.stny.rr.com>  <alpine.DEB.2.00.1109211007450.12914@router.home> <1316619103.29966.139.camel@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Sep 2011, Steven Rostedt wrote:

> The problem I have with this, is that this does not help at all. We are
> back to the word "this_cpu" when you really do mean "any_cpu". We

We mean the current cpu while the instruction is executing.

> Again, lets just bite the bullet and rename them to something that is
> understandable for everyone. This would make all of us happy.
>
> I'm not against your code, I'm against the naming convention you decided
> to use. It makes it confusing to something that is complex and complex
> code needs to try to be a simple as possible.

I am certainly open to new ways of structuring the stuff and for any
improvement possible. This whole scheme was developed in long discussions
over many years. My initial proposal was to use cpu_inc/dec etc. I did
what was possible in the context of the various opinions that people had
on these matters when the implementations were discussed. The "you" does
not apply. It is either "us" or "them" (if you want to distance yourself
from this).
