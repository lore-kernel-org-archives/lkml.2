Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757772Ab2I1Me4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 08:34:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:30334 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757247Ab2I1Mez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 08:34:55 -0400
X-Authority-Analysis: v=2.0 cv=Vb91zSV9 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=23BW25jA_k4A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=e7Wcmqxzby8A:10 a=D19gQVrFAAAA:8 a=OZg6xzbuTLz_ULNRFtkA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1348835692.22822.97.camel@gandalf.local.home>
Subject: Re: [PATCH -tip  0/3] Move kprobes files under the kprobes directory
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com
Date: Fri, 28 Sep 2012 08:34:52 -0400
In-Reply-To: <20120928081509.3560.8860.stgit@ltc138.sdl.hitachi.co.jp>
References: <20120928081509.3560.8860.stgit@ltc138.sdl.hitachi.co.jp>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-28 at 17:15 +0900, Masami Hiramatsu wrote:
> Hi,
> 
> Here are a series of patches to split ftrace-based kprobe part
> from arch/x86/kernel/kprobes.c and to move kprobes related
> files under arch/x86/kernel/kprobes/, according to Ingo's
> suggestion.
> https://lkml.org/lkml/2012/9/20/122
> 

Hi Masami,

Thanks for sending this. As it is getting very close to the merge
window, do you feel that his is good enough to push for 3.7, or do you
think we should hold off till 3.8, and let it brew a while?

-- Steve


