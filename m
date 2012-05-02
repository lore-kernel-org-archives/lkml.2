Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694Ab2EBWTc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 18:19:32 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:45539 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079Ab2EBWTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 18:19:31 -0400
MIME-Version: 1.0
In-Reply-To: <20120502211805.GH5745@infradead.org>
References: <1335987758-11039-1-git-send-email-acme@infradead.org>
 <1335988003.13683.182.camel@twins> <20120502211805.GH5745@infradead.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 2 May 2012 15:19:10 -0700
X-Google-Sender-Auth: T5YyMQPa5H6nRuQJQoG8aUQYSLQ
Message-ID: <CA+55aFzQisw4-jM94YdE9-i9+2NDLBNg3wV76t+oAHS9YwAX_g@mail.gmail.com>
Subject: Re: [GIT PULL 0/5] perf/annotate fixes and improvements
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 2, 2012 at 2:18 PM, Arnaldo Carvalho de Melo
<acme@infradead.org> wrote:
>
> Also the fixed vertical line is drawn after we refresh the lines, i.e.,
> it has a solid color, not influenced by each line percentages, as Linus
> noticed previously.

Looks good to me.  That said, I do wonder whether the vertical line
really is needed (or maybe it could be at the last decimal, so it only
shows for the instructions without percentages).

But with the color fixed, I doubt it annoys me nearly as much as it
used to. And the other cleanups have already meant that the horizontal
space is not as scarce a resource as it used to be.

                   Linus
