Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818Ab0GJW2C (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 18:28:02 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53294 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752959Ab0GJW2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 18:28:00 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTindHPEQHhmrB562ZlFZMtAIN-S6yMmT7zubS2D_@mail.gmail.com>
References: <1278705402.1537.157.camel@gandalf.stny.rr.com>
	<20100709203301.GA13839@merkur.ravnborg.org>
	<AANLkTinWkfkXNVA2Sx-apVQMZa-5ehugtd7JQ36np7xM@mail.gmail.com>
	<1278721339.1537.166.camel@gandalf.stny.rr.com>
	<20100710063459.GA14596@merkur.ravnborg.org>
	<AANLkTindHPEQHhmrB562ZlFZMtAIN-S6yMmT7zubS2D_@mail.gmail.com>
Date: Sat, 10 Jul 2010 15:27:25 -0700
Message-ID: <AANLkTilpiCs_yGVBA6AtaF4bqi8zVtZY7CggVZwZgfdh@mail.gmail.com>
Subject: Re: [PATCH] tracing: properly align linker defined symbols
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Zeev Tarantov <zeev.tarantov@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 10, 2010 at 3:25 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Here's an example patch. Untested. Whatever.

Ok, and by "untested", I clearly mean just that. I see a typo
immediately, but you get the idea.

  +#define MCOUNT_REC() \
  +	SYMBOL_SECTION(__mcount_lock, mcount_loc)

I'm too used to typing "lock", that __mcount_lock thing should
obviously be "__mcount_loc"

So take the patch as the RFC it is, and fix at least that typo before
actually testing it.

                          Linus
