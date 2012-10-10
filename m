Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757487Ab2JJXo2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 19:44:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38140 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754784Ab2JJXo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 19:44:27 -0400
Date: Wed, 10 Oct 2012 16:44:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kees Cook <keescook@chromium.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        PaX Team <pageexec@freemail.hu>
Subject: Re: [PATCH v2] fix stack memory content leak via UNAME26
Message-Id: <20121010164426.761987e0.akpm@linux-foundation.org>
In-Reply-To: <CAGXu5jJ_tQF9LUBgsAk+xdXTppGidakkd4gaDvGtSbpAeH21Dw@mail.gmail.com>
References: <20121009225401.GA10219@www.outflux.net>
	<20121010134646.4e9bba55.akpm@linux-foundation.org>
	<CAGXu5jJCQ3RxoFJ5FrGo=FJLSApK2PKX0PAt=E8y=PECNn4XWg@mail.gmail.com>
	<20121010154637.5b201ed7.akpm@linux-foundation.org>
	<CAGXu5jJ_tQF9LUBgsAk+xdXTppGidakkd4gaDvGtSbpAeH21Dw@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Oct 2012 16:36:44 -0700
Kees Cook <keescook@chromium.org> wrote:

> > would suffice?
> >
> > Not a big deal I guess, but copying out stuff beyond the NUL is a bit odd.
> 
> Sure, that looks good to me.

I think I'll stick with your tested patch for now.  Could you please
add "clean that up" to your todo list?

