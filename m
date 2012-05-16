Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932971Ab2EPTeX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 15:34:23 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:62290 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932760Ab2EPTeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 15:34:20 -0400
MIME-Version: 1.0
In-Reply-To: <1337175871.6724.46.camel@gandalf.stny.rr.com>
References: <1337175871.6724.46.camel@gandalf.stny.rr.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 16 May 2012 12:33:59 -0700
X-Google-Sender-Auth: pggMLCjO5Zwsr8iKNnPgLY6Ua3Y
Message-ID: <CA+55aFzVngkixn-t0mK8QqgnPhCzN2AsUtzfZ3BkLiJAcjNOzQ@mail.gmail.com>
Subject: Re: [RFC][PATCH] tracing: Remove useless 4 bytes of padding from
 every event
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Sharp <dsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 6:44 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> But this change will break PowerTop v1. Thus my question is, how long do
> we need to keep this wasted space in the ring buffers to satisfy an out
> of date tool?

The wasted space seems of limited importance.

More important is to check which distros have the new powertop.

F16 and F17 seem to have powertop-1.98, which I assume is the new
world order already. But maybe I assume incorrectly.

F14 (which I personally still use, since it doesn't have gnome3) is 1.13.

SuSE, Ubuntu?

                    Linus
