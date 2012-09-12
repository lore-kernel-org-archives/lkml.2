Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759048Ab2ILONi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 10:13:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:17301 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758949Ab2ILONd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 10:13:33 -0400
X-Authority-Analysis: v=2.0 cv=Vb91zSV9 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=jUoZk2RAzk0A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=xkD7W5DCUvkA:10 a=CelUsDXF5JJlFZLyqW0A:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1347459210.10751.48.camel@gandalf.local.home>
Subject: Re: [PATCH tip/core/rcu 04/15] rcu: Permit RCU_NONIDLE() to be used
 from interrupt context
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Date: Wed, 12 Sep 2012 10:13:30 -0400
In-Reply-To: <20120912010720.GM4257@linux.vnet.ibm.com>
References: <20120904230834.GB11494@jtriplet-mobl1>
	 <1346801031.27919.39.camel@gandalf.local.home>
	 <20120904233344.GB11855@jtriplet-mobl1>
	 <20120904234307.GY2593@linux.vnet.ibm.com>
	 <20120906185402.GB5738@jtriplet-mobl1>
	 <1346961244.1680.46.camel@gandalf.local.home> <20120907060940.GA21166@leaf>
	 <20120907142441.GD2462@linux.vnet.ibm.com> <20120907144717.GA22059@leaf>
	 <1347030967.8178.15.camel@gandalf.local.home>
	 <20120912010720.GM4257@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-09-11 at 18:07 -0700, Paul E. McKenney wrote:
>  
> > Paul, you just push your changes through tip, right? Then we can just
> > let Ingo know. I could even make the patch a separate branch, that Ingo
> > can pull into the RCU branch too.
> 
> Yep!  But we also need to worry about -next and -fengguang.
> 
> How about if you push your change into 3.7 and I push mine into 3.8?

Bah, this is what Linus said not to do. Although he's more about not
having this happen in a single merge window, but this isn't the "git
way".

There should be no problem in pushing the patch based off of Linus's
tree and have it be pulled into two branches. This is what Linus said he
wanted. The change will go in via one of the branches, whichever is
pulled first. And as the change will have the same SHA1 in both
branches, git will merge it nicely. This is what Linus said at kernel
summit that he wants people to do.

Note, this will also get into -next and -fengguang's tree as well,
without issue.

-- Steve


