Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765Ab0KHOCV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 09:02:21 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:54071 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754733Ab0KHOCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 09:02:17 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=rbwYpscXq5kA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=E3MmHjMt4svKmJBv5-oA:9 a=2xI6gc31P2UvG3BLxJN6L2KdryUA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] Tracing: do export trace_set_clr_event
From: Steven Rostedt <rostedt@goodmis.org>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Christoph Hellwig <hch@infradead.org>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
In-Reply-To: <5b55a1$ijitko@fmsmga002.fm.intel.com>
References: <1289196312-25323-1-git-send-email-yuanhan.liu@linux.intel.com>
	 <20101108095610.GA22592@infradead.org>
	 <5b55a1$ijitko@fmsmga002.fm.intel.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 08 Nov 2010 09:02:14 -0500
Message-ID: <1289224934.12418.1.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-08 at 10:14 +0000, Chris Wilson wrote:

> The question then became how to enable register tracing upon module load?
> This was the simpler proposal, add a module parameter to enable the
> tracepoints - hence the exporting of this routine. The alternative that we
> are mulling over is whether it is possible for ftrace to parse a trace= on
> every module load to manipulate the tracepoints within that module.

I like the trace=on parameter much better. If that is set we could
enable the tracepoints of that module at load time. I really do not want
to export the function that was proposed in that patch.

-- Steve


