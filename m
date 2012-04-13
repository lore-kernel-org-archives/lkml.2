Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756607Ab2DMTq5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 15:46:57 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:56090 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756025Ab2DMTq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 15:46:56 -0400
MIME-Version: 1.0
In-Reply-To: <20120413.152455.900761231064979707.davem@davemloft.net>
References: <20120413.152455.900761231064979707.davem@davemloft.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 13 Apr 2012 12:46:34 -0700
X-Google-Sender-Auth: d9R54zfNbrZtyeCw5c17I7UZ38g
Message-ID: <CA+55aFwYWRv6+ix+UjT52UAn1rQeDpUKmbWq5SdHjZ0qHR2Cbg@mail.gmail.com>
Subject: Re: [GIT] Sparc
To: David Miller <davem@davemloft.net>
Cc: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2012 at 12:24 PM, David Miller <davem@davemloft.net> wrote:
>
> With special guest sparc64 assembler hacker, Paul E. McKenney.

Oh christ.  You're teaching *more* people about sparc64?

Where will it end?

That said, Looking at the patch, it looks a bit dubious. Why does the

 		cmp			%l1, 0

instruction remain, even if the conditional branch was deleted? I'm
not seeing any subsequent uses of %icc, but hey, I'm no sparc expert
(nor do I want to be).

                      Linus
