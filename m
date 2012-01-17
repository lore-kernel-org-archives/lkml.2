Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887Ab2AQSvN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 13:51:13 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56148 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959Ab2AQSvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 13:51:12 -0500
MIME-Version: 1.0
In-Reply-To: <20120116151001.GB12817@redhat.com>
References: <20120110174509.GA30802@redhat.com> <20120113182015.GA3902@redhat.com>
 <20120115182441.GA24694@redhat.com> <20120116074540.GE15641@elte.hu>
 <1326717070.7642.144.camel@gandalf.stny.rr.com> <20120116125329.GB31667@elte.hu>
 <20120116151001.GB12817@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 17 Jan 2012 10:50:51 -0800
X-Google-Sender-Auth: u3GxTdIDGf9JzkollOIE5ossaNc
Message-ID: <CA+55aFwBW3abeSGoRMZBKERmSKk76Xm+uv7N+ZajvqOyv=aH3g@mail.gmail.com>
Subject: Re: [GIT PULL] tracing: make signal tracepoints more useful
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, Masami Hiramatsu <mhiramat@redhat.com>,
        Seiji Aguchi <saguchi@redhat.com>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 16, 2012 at 7:10 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>
> But do we really need to keep the old tracepoint? IOW, what if
> we simply rename it and add more info?

Quite frankly, unless somebody can point to something that breaks, I'd
rather just change the existing one.

Nobody outside of a few special cases uses tracepoints. *nobody*.  The
only apps I have ever seen that matters to anybody ends up being
latencytop and powertop. If those two have been tested and don't care,
I don't think we should care.

                       Linus
