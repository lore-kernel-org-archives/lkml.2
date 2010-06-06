Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757970Ab0FFPCk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 11:02:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:47199 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756410Ab0FFPCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 11:02:38 -0400
X-Authority-Analysis: v=1.1 cv=xm0otvE9/LjRWYlyDrHfx7zP0/MGCmNk7gQgTP1ehto= c=1 sm=0 a=PjWTFMnUE30A:10 a=0qYQvVkOOIcA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=VwQbUJbxAAAA:8 a=_CZM5PbzeyGrWGBg_lkA:9 a=LwWDxPOHPdrNFfrAic1-oT8iDZIA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: Perf trace event parse errors for KVM events
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Avi Kivity <avi@redhat.com>
Cc: Stefan Hajnoczi <stefanha@gmail.com>, linux-perf-users@vger.kernel.org,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>,
       Johannes Berg <johannes.berg@intel.com>,
       Darren Hart <darren@dvhart.com>
In-Reply-To: <4C0B577F.9050506@redhat.com>
References: <20100526123443.GB8905@stefan-thinkpad.transitives.com>
	 <AANLkTil8BiuzrmacV7Lpx1wES0EvLSiVmcfwtSY6Zis2@mail.gmail.com>
	 <1275083157.22648.593.camel@gandalf.stny.rr.com>
	 <4C00FF9B.9000107@redhat.com>
	 <1275139177.22648.610.camel@gandalf.stny.rr.com>
	 <4C021D7E.1060705@redhat.com>
	 <1275228182.15884.1.camel@gandalf.stny.rr.com>
	 <4C027131.2010309@redhat.com>
	 <1275233656.15884.4.camel@gandalf.stny.rr.com>
	 <4C04C739.8050607@redhat.com>
	 <1275393544.15884.19.camel@gandalf.stny.rr.com>
	 <4C04FF65.8020408@redhat.com>
	 <1275602225.15884.47.camel@gandalf.stny.rr.com>
	 <4C0B577F.9050506@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Sun, 06 Jun 2010 11:02:35 -0400
Message-ID: <1275836555.15884.83.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-06-06 at 11:08 +0300, Avi Kivity wrote:

> > Also, I kicked this off in kernelshark, and it made no difference that I
> > can see. This is because kernelshark only evaluates the viewable area of
> > the screen.
> >    
> 
> Neat.  Can it also search?  Where can I find it? <googles, finds, gawks>
> 

It's in the same repo as trace-cmd:

git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git

I'm still working on it. The latest is in the branch kernelshark-devel.

And yes, it does searches.

-- Steve


