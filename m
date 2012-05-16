Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965412Ab2EPTvZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 15:51:25 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:62874 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964842Ab2EPTvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 15:51:23 -0400
MIME-Version: 1.0
In-Reply-To: <4FB401B2.1010906@linux.intel.com>
References: <1337175871.6724.46.camel@gandalf.stny.rr.com> <CA+55aFzVngkixn-t0mK8QqgnPhCzN2AsUtzfZ3BkLiJAcjNOzQ@mail.gmail.com>
 <4FB401B2.1010906@linux.intel.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 16 May 2012 12:51:02 -0700
X-Google-Sender-Auth: HDOVernsj5_J5Le3XAKUFkuIKwU
Message-ID: <CA+55aFyGkxwmzqca6GZmQzwTbU_TL_SWeBUpHfcWWiOQro2Ruw@mail.gmail.com>
Subject: Re: [RFC][PATCH] tracing: Remove useless 4 bytes of padding from
 every event
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        David Sharp <dsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 12:36 PM, Arjan van de Ven
<arjan@linux.intel.com> wrote:
>
> this is the one that will break

Oh, ok. So we need to wait at *least* for F16/F17 to upgrade. I assume
that SuSE/Ubuntu are in the same boat.

>> F14 (which I personally still use, since it doesn't have gnome3) is 1.13.
>
> this one is fine, it does not use perf events at all.

Ok. Sadly, my actual laptop (which is where I've used it) runs F17
these days, since F14 can't handle the SNB graphics. So I'd actually
notice.

Steven is foiled again.

                  Linus
