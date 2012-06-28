Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153Ab2F1Bws (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 21:52:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8786 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447Ab2F1Bwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 21:52:47 -0400
X-Authority-Analysis: v=2.0 cv=StQSGYy0 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=sNxammv2Ed8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=20KFwNOVAAAA:8 a=QAcFfF0SEkZH8JmhXPMA:9 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1340848364.16702.56.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 2/4] KVM: Use __print_hex() for kvm_emulate_insn
 tracepoint
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Avi Kivity <avi@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>, kvm@vger.kernel.org,
        dsahern@gmail.com
Date: Wed, 27 Jun 2012 21:52:44 -0400
In-Reply-To: <87bok4z157.fsf@sejong.aot.lge.com>
References: <1340757701-10711-1-git-send-email-namhyung@kernel.org>
	 <1340757701-10711-2-git-send-email-namhyung@kernel.org>
	 <1340801375.16702.10.camel@gandalf.stny.rr.com>
	 <4FEB0288.5080106@redhat.com>
	 <1340803224.16702.12.camel@gandalf.stny.rr.com>
	 <87bok4z157.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-28 at 10:16 +0900, Namhyung Kim wrote:
> [CC'ing David]
> 
> Hi, Steve
> 
> On Wed, 27 Jun 2012 09:20:24 -0400, Steven Rostedt wrote:
> > On Wed, 2012-06-27 at 15:54 +0300, Avi Kivity wrote:
> >
> >> Acked-by: Avi Kivity <avi@redhat.com>
> >
> > Thanks Avi!
> >
> 
> Can you give me your ack's too (for this and other ones in the series)?
> And if you ok, I can route this and future changes (from anybody) on
> libtraceevent through my tree.
> 

Actually, as this patch touches x86 and ftrace, and does not truly
affect the tools directory, I've already added it into my queue for 3.6.

-- Steve


