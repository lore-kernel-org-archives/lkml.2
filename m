Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225Ab2JTEa2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 00:30:28 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:53621 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158Ab2JTEa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 00:30:26 -0400
MIME-Version: 1.0
In-Reply-To: <20121019202204.76666c39.akpm@linux-foundation.org>
References: <20121020014553.GA6785@www.outflux.net>
	<20121019202204.76666c39.akpm@linux-foundation.org>
Date: Fri, 19 Oct 2012 21:30:24 -0700
X-Google-Sender-Auth: V4UeeQehPXIts4oWP4mwn33JiR8
Message-ID: <CAGXu5j+80oat9gkq6-9vtMUo33BC8D=A1rPQF5yE89M-Kq=G7g@mail.gmail.com>
Subject: Re: [PATCH] use clamp_t in UNAME26 fix
From: Kees Cook <keescook@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Fengguang Wu <fengguang.wu@intel.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Argh, whoops. Greg, can you please include
31fd84b95eb211d5db460a1dda85e004800a7b52 in stable?

Thanks,

-Kees

On Fri, Oct 19, 2012 at 8:22 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Fri, 19 Oct 2012 18:45:53 -0700 Kees Cook <keescook@chromium.org> wrote:
>
>>
>> The min/max call needed to have explicit types on some architectures
>> (e.g. mn10300). Use clamp_t instead to avoid the warning.
>>
>> kernel/sys.c: In function 'override_release':
>> kernel/sys.c:1287:10: warning: comparison of distinct pointer types lacks a cast [enabled by default]
>>
>> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>
> Needs a cc:stable in the changelog before committing, please.



-- 
Kees Cook
Chrome OS Security
