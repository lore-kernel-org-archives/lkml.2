Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757265Ab2EUQ5F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 12:57:05 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:63595 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757118Ab2EUQ5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 12:57:03 -0400
MIME-Version: 1.0
In-Reply-To: <20120521071622.GA30748@gmail.com>
References: <CAKfTPtDSDAOAdv0GTDswZeRM7TmACrjok+5kddSaQpvy6_6xWw@mail.gmail.com>
 <CAKfTPtCfiY7A29+e50F+6awd8BjNJjg4=uNN4ReZfdS_4FbpkA@mail.gmail.com>
 <1337084609.27020.156.camel@laptop> <CAKfTPtDz1-fR2i5x7AVd8sGZhX2VNtz2rnQC3ePrcHO9MWK3FQ@mail.gmail.com>
 <1337086834.27020.162.camel@laptop> <CAKfTPtDrZ-tfC81jnxwpB+DCtmxhU+VfoYbtSBr8MkFt+P8JcA@mail.gmail.com>
 <1337096141.27694.82.camel@twins> <1337193010.27694.146.camel@twins>
 <CA+55aFzuygx6L-2hVCMbk5cvEdDp6AUtOGq-wYFn=4yEyebPLw@mail.gmail.com>
 <1337469731.573.154.camel@twins> <20120521071622.GA30748@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 21 May 2012 09:56:42 -0700
X-Google-Sender-Auth: xxDwxqi_xL3OMiH2jEnQ4cPpVnc
Message-ID: <CA+55aFxVkJ0Ya8nZAD+pRro+xRCydqcTSFsRcr=MdmgbaqZY4Q@mail.gmail.com>
Subject: Re: Plumbers: Tweaking scheduler policy micro-conf RFP
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        paulmck@linux.vnet.ibm.com, smuckle@quicinc.com, khilman@ti.com,
        Robin.Randhawa@arm.com, suresh.b.siddha@intel.com,
        thebigcorporation@gmail.com, venki@google.com,
        panto@antoniou-consulting.com, mingo@elte.hu, paul.brett@intel.com,
        pdeschrijver@nvidia.com, pjt@google.com, efault@gmx.de,
        fweisbec@gmail.com, geoff@infradead.org, rostedt@goodmis.org,
        tglx@linutronix.de, amit.kucheria@linaro.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linaro-sched-sig@lists.linaro.org,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Juri Lelli <juri.lelli@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 12:16 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> Nevertheless I'll wait for Linus to confirm that he agrees
> violently as well, before sending these bits ;-)

So as long as people aren't going to do some arch-specific scheduling,
I don't care. It sounds like I misread what Peter's intentions were.

And line count removal is always a good sign.

                  Linus
