Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339Ab2EPUDq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 16:03:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7951 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755138Ab2EPUDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 16:03:44 -0400
X-Authority-Analysis: v=2.0 cv=D8PF24tj c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=XlIr_nCh6zIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=QyXUC8HyAAAA:8 a=COTEx2FOcDUZWVcMcuMA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1337198622.6724.83.camel@gandalf.stny.rr.com>
Subject: Re: [RFC][PATCH] tracing: Remove useless 4 bytes of padding from
 every event
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Sharp <dsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 16 May 2012 16:03:42 -0400
In-Reply-To: <CA+55aFyGkxwmzqca6GZmQzwTbU_TL_SWeBUpHfcWWiOQro2Ruw@mail.gmail.com>
References: <1337175871.6724.46.camel@gandalf.stny.rr.com>
	 <CA+55aFzVngkixn-t0mK8QqgnPhCzN2AsUtzfZ3BkLiJAcjNOzQ@mail.gmail.com>
	 <4FB401B2.1010906@linux.intel.com>
	 <CA+55aFyGkxwmzqca6GZmQzwTbU_TL_SWeBUpHfcWWiOQro2Ruw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-16 at 12:51 -0700, Linus Torvalds wrote:
> On Wed, May 16, 2012 at 12:36 PM, Arjan van de Ven
> <arjan@linux.intel.com> wrote:
> >
> > this is the one that will break
> 
> Oh, ok. So we need to wait at *least* for F16/F17 to upgrade. I assume
> that SuSE/Ubuntu are in the same boat.

Ah, so you just answered the email I sent while you sent this one. You
must be psychic. 

> 
> >> F14 (which I personally still use, since it doesn't have gnome3) is 1.13.
> >
> > this one is fine, it does not use perf events at all.
> 
> Ok. Sadly, my actual laptop (which is where I've used it) runs F17
> these days, since F14 can't handle the SNB graphics. So I'd actually
> notice.
> 
> Steven is foiled again.

/me curses! That damn rascal Linus!



