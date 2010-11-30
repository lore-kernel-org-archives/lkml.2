Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244Ab0K3Oqa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 09:46:30 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:36073 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877Ab0K3Oq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 09:46:28 -0500
X-Authority-Analysis: v=1.1 cv=6ptpMFIBtxRk0xdOb6IhJTbTLVRlKjWFes7R4SsWCrA= c=1 sm=0 a=qK-MKYc896kA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=v-1sjdctxtBzdkx4BhoA:9 a=Nq1X4wQ_rON_DoIdo0TOCmJFsnEA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 3/3 V13] RO/NX protection for loadable kernel
From: Steven Rostedt <rostedt@goodmis.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: matthieu castet <castet.matthieu@free.fr>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-next@vger.kernel.org,
        Arjan van de Ven <arjan@infradead.org>,
        James Morris <jmorris@namei.org>,
        Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, Stephen Rothwell <sfr@canb.auug.org.au>,
        Dave Jones <davej@redhat.com>, Siarhei Liakh <sliakh.lkml@gmail.com>,
        Kees Cook <kees.cook@canonical.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <201011301005.29532.rusty@rustcorp.com.au>
References: <4CE2F914.9070106@free.fr>
	 <20101129181542.GA11630@home.goodmis.org>
	 <201011301005.29532.rusty@rustcorp.com.au>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 30 Nov 2010 09:46:23 -0500
Message-ID: <1291128383.27486.35.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-30 at 10:05 +1030, Rusty Russell wrote:
> On Tue, 30 Nov 2010 04:45:42 am Steven Rostedt wrote:
> > This patch breaks function tracer:
> ...
> > Here we set the text read only before we call the notifiers. The
> > function tracer changes the calls to mcount into nops via a notifier
> > call so this must be done after the module notifiers.
> 
> That seems fine.
> 
> I note that both before and after this patch we potentially execute code
> in the module (via parse_args) before we set it ro & nx.  But fixing this
> last bit of coverage is probably not worth the pain...

Rusty, can I take this as an "Acked-by"?

Thanks,

-- Steve


