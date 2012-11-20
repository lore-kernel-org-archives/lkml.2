Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032Ab2KTPz7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 10:55:59 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15399 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769Ab2KTPz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 10:55:57 -0500
X-Authority-Analysis: v=2.0 cv=dttZ+ic4 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Wu0uEauASpgA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=gAuBvx7K2IcA:10 a=Mg2bPhSwYpk1OuVmy0UA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1353426955.6276.24.camel@gandalf.local.home>
Subject: Re: [PATCH] arch_check_bp_in_kernelspace: fix the range check
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Amnon Shiloh <u3557@miso.sublimeip.com>, linux-kernel@vger.kernel.org
Date: Tue, 20 Nov 2012 10:55:55 -0500
In-Reply-To: <20121120154824.GA17534@redhat.com>
References: <20121109182943.GA2789@redhat.com>
	 <20121109183026.GA2719@redhat.com> <20121119174728.GA11365@redhat.com>
	 <1353349500.6276.9.camel@gandalf.local.home>
	 <20121120154824.GA17534@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-11-20 at 16:48 +0100, Oleg Nesterov wrote:

> > But here, there's no prejudice between tasks. All tasks will now hit the
> > breakpoint regardless of if it is being traced or not.
>   ^^^^^^^^^^
> 
> This is hardware breakpoint, it is per-task.

I forgot that hw breakpoints are swapped out at context switch (as Amnon
informed me). 

OK, that makes a big difference.

Thanks,

-- Steve


