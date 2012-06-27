Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749Ab2F0NU2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 09:20:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8366 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835Ab2F0NU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 09:20:26 -0400
X-Authority-Analysis: v=2.0 cv=IOWA+3TG c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=sNxammv2Ed8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=20KFwNOVAAAA:8 a=QYnoWoakAAAA:8 a=uIEpHsUg4xVJd3rGjr0A:9 a=PUjeQqilurYA:10 a=2pWR6aS4NxUA:10 a=jEp0ucaQiEUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1340803224.16702.12.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 2/4] KVM: Use __print_hex() for kvm_emulate_insn
 tracepoint
From: Steven Rostedt <rostedt@goodmis.org>
To: Avi Kivity <avi@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>, kvm@vger.kernel.org
Date: Wed, 27 Jun 2012 09:20:24 -0400
In-Reply-To: <4FEB0288.5080106@redhat.com>
References: <1340757701-10711-1-git-send-email-namhyung@kernel.org>
	  <1340757701-10711-2-git-send-email-namhyung@kernel.org>
	 <1340801375.16702.10.camel@gandalf.stny.rr.com>
	 <4FEB0288.5080106@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-27 at 15:54 +0300, Avi Kivity wrote:

> Acked-by: Avi Kivity <avi@redhat.com>

Thanks Avi!

> 
> Some time ago we discussed moving the trace-cmd plugins to /lib/modules,
> which would make this trace display as "mov %edx,(%eax)" instead of "89
> 10", even for non-trace-cmd users.  Was there any movement on this?
> 

As a matter of fact ;-)  The trace-cmd libparsevent library has now been
moved to tools/lib/libtraceevent, in which perf now uses. It is just a
matter of time till perf gets the use of the trace-cmd plugins. We just
need to figure out the logistics.

Maybe make a tools/event_plugins ?

Or something to that affect?

-- Steve


