Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758457Ab2C1Tqs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 15:46:48 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:36343 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941Ab2C1Tqr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 15:46:47 -0400
MIME-Version: 1.0
In-Reply-To: <20120327181547.GA7374@infradead.org>
References: <20120327181547.GA7374@infradead.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 28 Mar 2012 12:46:25 -0700
X-Google-Sender-Auth: DR9vfL1Y4sXtz4SvRNe7d_Iam8U
Message-ID: <CA+55aFynFze+AJxUtkiAaOTJ58cK8=aiDi-fQqQ3bDV54w-=+A@mail.gmail.com>
Subject: Re: [RFC] perf tools: Including pre-generated flex files
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 27, 2012 at 11:15 AM, Arnaldo Carvalho de Melo
<acme@infradead.org> wrote:
>
>        But Ingo argues that flex and bison are just a yum/whatever
> install away, so we shouldn't clutter the kernel git history with things
> we can generate at build time.
>
>        What is your take on this?

I think I agree.

Building the *basic* kernel is different - I want people to be able to
build the kernel and install it and test it out with a fairly minimal
development environment.

But the perf tools
 (a) are mainly useful for developers who can easily install these
things *anyway* (ie we're not talking the same kind of usage cases
where we want to encourage random people off the street to build and
test)
 (b) already require things that are *much* less common than flex (ie
the whole libelf-devel stuff etc)
so I think having pre-generated lex/yacc files is just silly - just
install the tool.

                    Linus
