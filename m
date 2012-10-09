Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369Ab2JIRN7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 13:13:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31958 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373Ab2JIRN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 13:13:56 -0400
X-Authority-Analysis: v=2.0 cv=a96yBDuF c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=F0my4ousGMIA:10 a=swrB9e8O9tExfjkHIvsA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1349802833.24256.25.camel@gandalf.local.home>
Subject: Re: [ANNOUNCE] 3.6.1-rt1
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Carsten Emde <cbe@osadl.org>
Date: Tue, 09 Oct 2012 13:13:53 -0400
In-Reply-To: <alpine.LFD.2.02.1210091811540.10988@ionos>
References: <alpine.LFD.2.02.1210091535140.10988@ionos>
	 <1349795389.24256.20.camel@gandalf.local.home>
	 <alpine.LFD.2.02.1210091811540.10988@ionos>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-09 at 18:19 +0200, Thomas Gleixner wrote:
>  
> > I've started looking at playing with the NAPI code again, and trying to
> > see if I can add an ENAPI interface (Even Newer API), where the driver
> > uses its own interrupt thread, and instead of having the polling in the
> > network softirq, it can do the polling in its own thread.
> 
> It's pretty close to the behaviour I enforced with this change. Let's
> play with that and figure out what influence it has on the network
> throughput performance on RT. That needs probably a different
> scheduling scheme than what Carsten needs for his deterministic
> behaviour.
> 

I was actually looking at the change for mainline, not for -rt ;-)

-- Steve


