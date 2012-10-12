Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759484Ab2JLLmD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 07:42:03 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:19018 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178Ab2JLLmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 07:42:01 -0400
X-Authority-Analysis: v=2.0 cv=e+uEuNV/ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=14TX3ak_UBEA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=FfOpIHPiV7sA:10 a=1XWaLZrsAAAA:8 a=yJuRf0tINcfX95y1KwEA:9 a=PUjeQqilurYA:10 a=UTB_XpHje0EA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1350042118.24256.93.camel@gandalf.local.home>
Subject: Re: [PATCH v6 1/6] tracing,x86: Add a TSC trace_clock
From: Steven Rostedt <rostedt@goodmis.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: David Sharp <dhsharp@google.com>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Date: Fri, 12 Oct 2012 07:41:58 -0400
In-Reply-To: <CAMuHMdVx5PU--fo+J1c04qcdG6r+B1DJwD6cxR8evFAyVpJBHQ@mail.gmail.com>
References: <1349998076-15495-1-git-send-email-dhsharp@google.com>
	 <1349998076-15495-2-git-send-email-dhsharp@google.com>
	 <CAMuHMdVx5PU--fo+J1c04qcdG6r+B1DJwD6cxR8evFAyVpJBHQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-12 at 07:05 +0200, Geert Uytterhoeven wrote:
> On Fri, Oct 12, 2012 at 1:27 AM, David Sharp <dhsharp@google.com> wrote:
> > +#include <asm-generic/trace_clock.h>
> 
> Please use the Kbuild infrastructure ("generic-y += ..." in
> arch/*/include/asm/Kbuild)
> instead of adding wrappers around the asm-generic version.

So that's how that's done. Learn something new everyday. Too bad the one
file I checked (div64.h) doesn't seem to do it for ia64 and others.

Can we please have someone clean up all the archs and remove any *.h
wrappers and use the kbuild infrastructure instead. That way, when
another developer goes to look at how this is done, they wont copy the
wrong method again. (Maybe I'll just do it :-p)

David,

Can you just send an update of this one patch.

Thanks,

-- Steve



