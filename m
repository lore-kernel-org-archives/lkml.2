Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933145Ab2JKAj3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 20:39:29 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:43811 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932872Ab2JKAjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 20:39:24 -0400
MIME-Version: 1.0
In-Reply-To: <20121010164426.761987e0.akpm@linux-foundation.org>
References: <20121009225401.GA10219@www.outflux.net>
	<20121010134646.4e9bba55.akpm@linux-foundation.org>
	<CAGXu5jJCQ3RxoFJ5FrGo=FJLSApK2PKX0PAt=E8y=PECNn4XWg@mail.gmail.com>
	<20121010154637.5b201ed7.akpm@linux-foundation.org>
	<CAGXu5jJ_tQF9LUBgsAk+xdXTppGidakkd4gaDvGtSbpAeH21Dw@mail.gmail.com>
	<20121010164426.761987e0.akpm@linux-foundation.org>
Date: Wed, 10 Oct 2012 17:39:23 -0700
X-Google-Sender-Auth: XaqbSrTJOC9SDxloFUiL0yzrovs
Message-ID: <CAGXu5jJFN3CRVH6=39PVKw4QJXaGt7NRu-UO7u5xCKv+nxi6+w@mail.gmail.com>
Subject: Re: [PATCH v2] fix stack memory content leak via UNAME26
From: Kees Cook <keescook@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        PaX Team <pageexec@freemail.hu>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 10, 2012 at 4:44 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Wed, 10 Oct 2012 16:36:44 -0700
> Kees Cook <keescook@chromium.org> wrote:
>
>> > would suffice?
>> >
>> > Not a big deal I guess, but copying out stuff beyond the NUL is a bit odd.
>>
>> Sure, that looks good to me.
>
> I think I'll stick with your tested patch for now.  Could you please
> add "clean that up" to your todo list?

Sure. I've sent a v3 now. It still needed to handle the (theoretical)
len == 0 case, though.

-Kees

-- 
Kees Cook
Chrome OS Security
