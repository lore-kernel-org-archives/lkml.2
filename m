Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024Ab0KJNVv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 08:21:51 -0500
Received: from mail.windriver.com ([147.11.1.11]:49521 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755857Ab0KJNVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 08:21:50 -0500
Message-ID: <4CDA9C5C.6010904@windriver.com>
Date: Wed, 10 Nov 2010 07:21:32 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20101027)
MIME-Version: 1.0
To: jovi zhang <bookjovi@gmail.com>
CC: Martin Hicks <mort@sgi.com>, Dmitry Torokhov <dtor@mail.ru>,
        Rusty Russell <rusty@rustcorp.com.au>,
        kgdb-bugreport@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kdb: use macro instead of const number
References: <AANLkTi=b+KWcYqXCteuiw0OnKqfSvWQCA+B-HUEy90R8@mail.gmail.com>
In-Reply-To: <AANLkTi=b+KWcYqXCteuiw0OnKqfSvWQCA+B-HUEy90R8@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Nov 2010 13:21:33.0487 (UTC) FILETIME=[31AD7BF0:01CB80DA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 3 patches you have sent me so far all have white space that is
completely mangled.  In the future, please use a mail client that does
not mangle white space, or use "git send-email".

I did fix up your patches so as to add them to the merge queue.  The
code cleanup (this patch) will be deferred to the next merge window.

Please see my other comment about signed off by tags.


On 11/10/2010 04:51 AM, jovi zhang wrote:
> It's better to use macro KDB_BASE_CMD_MAX instead of 50
>
> Signed-off-by: jovi zhang <bookjovi@gmail.com>
>   

For a signed off tag, you want to make sure these are consistent for all
the patches you send to any kernel maintainer or kernel mailing list. 
You already have one patch in the kernel
(85e00b55517a5696282b80836655e6b6f5702df0), and it does not match your
signed-off-by line.

If you are using git to make your patches, please edit the ~/.gitconfig
and use something like:
[user]
        name = Jovi Zhang
        email = bookjovi@gmail.com

Thanks,
Jason.

> kernel/debug/kdb/kdb_main.c |    2 +-
> 1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
> index 37755d6..3579105 100644
> --- a/kernel/debug/kdb/kdb_main.c
> +++ b/kernel/debug/kdb/kdb_main.c
> @@ -78,7 +78,7 @@ static unsigned int kdb_continue_catastrophic;
> static kdbtab_t *kdb_commands;
> #define KDB_BASE_CMD_MAX 50
> static int kdb_max_commands = KDB_BASE_CMD_MAX;
> -static kdbtab_t kdb_base_commands[50];
> +static kdbtab_t kdb_base_commands[KDB_BASE_CMD_MAX];
> #define for_each_kdbcmd(cmd, num)                                      \
>        for ((cmd) = kdb_base_commands, (num) = 0;                      \
>             num < kdb_max_commands;                                    \
>   

