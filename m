Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970Ab2JFS0V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 14:26:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6879 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968Ab2JFS0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 14:26:20 -0400
X-Authority-Analysis: v=2.0 cv=dvhZ+ic4 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=zYQHrSgTeTAA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=_67WK3i7ub8A:10 a=n6c3tSd2smW548EdFJ4A:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1349547977.6755.108.camel@gandalf.local.home>
Subject: Re: [PATCH v4] trace,x86: add x86 irq vector tracepoints
From: Steven Rostedt <rostedt@goodmis.org>
To: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Seiji Aguchi <seiji.aguchi@hds.com>,
        "Thomas Gleixner (tglx@linutronix.de)" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "'mingo@elte.hu' (mingo@elte.hu)" <mingo@elte.hu>,
        "x86@kernel.org" <x86@kernel.org>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Date: Sat, 06 Oct 2012 14:26:17 -0400
In-Reply-To: <20121006173231.GA6110@liondog.tnic>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D41385F33C@USINDEM103.corp.hds.com>
	 <50612729.2080307@zytor.com>
	 <A5ED84D3BB3A384992CBB9C77DEDA4D41386426D@USINDEM103.corp.hds.com>
	 <50650A7E.90807@zytor.com>
	 <A5ED84D3BB3A384992CBB9C77DEDA4D413869FD7@USINDEM103.corp.hds.com>
	 <1349446428.6755.56.camel@gandalf.local.home> <506F7849.2080805@zytor.com>
	 <1349492261.6755.87.camel@gandalf.local.home>
	 <20121006130532.GB11120@liondog.tnic>
	 <1349535105.6755.104.camel@gandalf.local.home>
	 <20121006173231.GA6110@liondog.tnic>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-10-06 at 19:32 +0200, Borislav Petkov wrote:

> > 2) Are the tracepoints done in a way that it's not going to cause "ABI"
> > issues. If not then we need to redesign the tracepoints.
> 
> Btw, this we should be asking ourselves about *all* TPs, especially if
> they're in generic code.

I agree, and I'm starting to think I shouldn't have given free reign
over the TPs to system maintainers. That is, I should have pushed harder
to understand all tracepoints added to code to make sure the maintainer
knows that it can become an ABI.

Some maintainers don't worry about it. But I can see it coming back to
haunt them. In the end, it will hurt the maintainer of the code, which
is why I gave the ownership of tracepoints to locations where they are
at (instead of a "joint" ownership). But I probably should have been a
TP cop for a while to allow them to understand the consequences first.

-- Steve


