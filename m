Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378Ab2HGN3g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 09:29:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28477 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734Ab2HGN3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 09:29:35 -0400
X-Authority-Analysis: v=2.0 cv=ZuBv2qHG c=1 sm=0 a=s5Htg7xnQOKvHEu9STBOug==:17 a=OpT9cpI26MMA:10 a=3Odpp9koIGIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=G82mWhbSZBEONZ6PcpMA:9 a=PUjeQqilurYA:10 a=s5Htg7xnQOKvHEu9STBOug==:117
X-Cloudmark-Score: 0
X-Originating-IP: 72.230.195.127
Message-ID: <1344346173.6935.4.camel@gandalf.stny.rr.com>
Subject: Re: Testing tracer wakeup_rt: .. no entries found ..FAILED!
From: Steven Rostedt <rostedt@goodmis.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Avi Kivity <avi@redhat.com>, Steven Rostedt <srostedt@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Date: Tue, 07 Aug 2012 09:29:33 -0400
In-Reply-To: <20120731235725.GB5673@localhost>
References: <20120724090330.GA9830@localhost>
	 <20120724090720.GA10434@localhost> <1343663105.3847.7.camel@fedora>
	 <20120731121759.GA17822@localhost> <5017D19B.5080806@redhat.com>
	 <1343738627.27983.30.camel@gandalf.stny.rr.com>
	 <5017D4AB.3090107@redhat.com>
	 <1343740419.27983.33.camel@gandalf.stny.rr.com>
	 <20120731234336.GA5526@localhost>
	 <1343778699.27983.70.camel@gandalf.stny.rr.com>
	 <20120731235725.GB5673@localhost>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-08-01 at 07:57 +0800, Fengguang Wu wrote:
> > 
> > What was the next lines? I bet you it was "PASSED". Which means it did
> > not fail. This is the second bug you found that has to do with RCU being
> > called in 'idle'. The one that Paul posted a patch for.
> 
> Yeah, PASSED!

I have this patch queued for 3.7. Can I add your 'Tested-by' for it.

Thanks,

-- Steve

> 
> [    2.898070]  [<8117ea5e>] time_hardirqs_on+0x1de/0x220
> [    2.898070]  [<81013313>] ? default_idle+0x593/0xc30
> [    2.898070]  [<81109d6d>] trace_hardirqs_on_caller+0x2d/0x380
> [    2.898070]  [<8110a0e7>] trace_hardirqs_on+0x27/0x40
> [    2.898070]  [<81013313>] default_idle+0x593/0xc30
> [    2.898070]  [<8101692d>] cpu_idle+0x2dd/0x390
> [    2.898070]  [<817fbe97>] start_secondary+0x44b/0x460
> [    3.150115] PASSED
> [    3.390079] Testing tracer function_graph: PASSED
> 
> I'll test Paul's patch on top of yours right away.
> 
> Thanks,
> Fengguang


