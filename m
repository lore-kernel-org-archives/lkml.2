Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538Ab2GaCc1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 22:32:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:19141 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755475Ab2GaCcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 22:32:17 -0400
X-Authority-Analysis: v=2.0 cv=LIjkseq9 c=1 sm=0 a=s5Htg7xnQOKvHEu9STBOug==:17 a=OpT9cpI26MMA:10 a=7Npo2C4X2bcA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=Zm1eqm45Yv6vzhNRxasA:9 a=PUjeQqilurYA:10 a=s5Htg7xnQOKvHEu9STBOug==:117
X-Cloudmark-Score: 0
X-Originating-IP: 72.230.195.127
Message-ID: <1343701935.27983.18.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH RT 05/12] slab: Prevent local lock deadlock
From: Steven Rostedt <rostedt@goodmis.org>
To: frank.rowand@am.sony.com
Cc: "Rowand, Frank" <Frank_Rowand@sonyusa.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "chris.pringle@miranda.com" <chris.pringle@miranda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Carsten Emde <C.Emde@osadl.org>, John Kacur <jkacur@redhat.com>
Date: Mon, 30 Jul 2012 22:32:15 -0400
In-Reply-To: <50174158.4000408@am.sony.com>
References: <20120718223910.898476857@goodmis.org>
		 <20120718223957.856443728@goodmis.org> <5011DD9B.1030901@am.sony.com>
	 <1343697755.27983.17.camel@gandalf.stny.rr.com>
	 <50174158.4000408@am.sony.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-30 at 19:22 -0700, Frank Rowand wrote:
> On 07/30/12 18:22, Steven Rostedt wrote:
> > On Thu, 2012-07-26 at 17:15 -0700, Frank Rowand wrote:
> > 
> >>
> >> Config is from arch/arm/configs/omap2plus_defconfig
> >> plus:
> >>
> >>    CONFIG_USB_EHCI_HCD=y
> >>    CONFIG_USB_NET_SMSC95XX=y
> >>    CONFIG_PREEMPT_RT_FULL=y
> >>
> > 
> > Interesting, I just booted my panda board against 3.0.36-rt58 with that
> > config and these three set, and I didn't get this error.
> 
> I don't know if it makes any difference, but my root fs is nfs mounted.
> 
> I'll try to look at this some more tomorrow.
> 

Yeah, my root fs is on the sdcard. Did you get this bug every time or
was it sporadic?

-- Steve


