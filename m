Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964820Ab2ERQkB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 12:40:01 -0400
Received: from casper.infradead.org ([85.118.1.10]:60624 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932535Ab2ERQj6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 12:39:58 -0400
Message-ID: <1337359187.573.105.camel@twins>
Subject: Re: Plumbers: Tweaking scheduler policy micro-conf RFP
From: Peter Zijlstra <peterz@infradead.org>
To: Morten Rasmussen <Morten.Rasmussen@arm.com>
Cc: "panto@antoniou-consulting.com" <panto@antoniou-consulting.com>,
        "smuckle@quicinc.com" <smuckle@quicinc.com>,
        Juri Lelli <juri.lelli@gmail.com>, "mingo@elte.hu" <mingo@elte.hu>,
        "linaro-sched-sig@lists.linaro.org" 
	<linaro-sched-sig@lists.linaro.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "geoff@infradead.org" <geoff@infradead.org>,
        "efault@gmx.de" <efault@gmx.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Paul Turner <pjt@google.com>
Date: Fri, 18 May 2012 18:39:47 +0200
In-Reply-To: <20120518162445.GF18312@e103034-lin.cambridge.arm.com>
References: <CAKfTPtDSDAOAdv0GTDswZeRM7TmACrjok+5kddSaQpvy6_6xWw@mail.gmail.com>
	 <CAKfTPtCfiY7A29+e50F+6awd8BjNJjg4=uNN4ReZfdS_4FbpkA@mail.gmail.com>
	 <1337084609.27020.156.camel@laptop>
	 <CAKfTPtDz1-fR2i5x7AVd8sGZhX2VNtz2rnQC3ePrcHO9MWK3FQ@mail.gmail.com>
	 <1337086834.27020.162.camel@laptop>
	 <CAKfTPtDrZ-tfC81jnxwpB+DCtmxhU+VfoYbtSBr8MkFt+P8JcA@mail.gmail.com>
	 <1337096141.27694.82.camel@twins>
	 <20120518161817.GE18312@e103034-lin.cambridge.arm.com>
	 <20120518162445.GF18312@e103034-lin.cambridge.arm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-18 at 17:24 +0100, Morten Rasmussen wrote:
> One more thing. I have experimented with PJT's load-tracking patchset
> and found it very useful for big.LITTLE scheduling. Is there any plans
> for including them? 

Yes.. as soon as PJT comes out of the deep dark caves of googleplex and
posts them again (provided they pass review etc.. but since they already
had a go I'm fairly confident).

Paul you reading?
