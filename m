Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359Ab2DPW5n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 18:57:43 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:44144 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030Ab2DPW5m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 18:57:42 -0400
MIME-Version: 1.0
In-Reply-To: <20120417084707.318091fd28f6dd306e891195@canb.auug.org.au>
References: <1334598461-3160-1-git-send-email-wad@chromium.org>
	<20120417084707.318091fd28f6dd306e891195@canb.auug.org.au>
Date: Mon, 16 Apr 2012 17:57:40 -0500
Message-ID: <CABqD9hb7BcjFiYSKThjF8AH6uKw56ZEJHmuJ9zt=c59Rc=3RSg@mail.gmail.com>
Subject: Re: [PATCH] seccomp: ignore secure_computing return values
From: Will Drewry <wad@chromium.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: jmorris@namei.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2012 at 5:47 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Will,
>
> On Mon, 16 Apr 2012 12:47:41 -0500 Will Drewry <wad@chromium.org> wrote:
>>
>> Unless an architecture selects CONFIG_HAVE_ARCH_SECCOMP_FILTER, it
>> is not required to respect the return value from secure_computing().
>>
>> This change matches https://lkml.org/lkml/2012/4/16/14 exactly except
>> that it applies cleanly to security-next.  Because there is no
>> other difference than the alignment, I've kept Signed-off-by intact.
>
> Given that, I think you should have kept the authorship (i.e. put
>
> From: Stephen Rothwell <sfr@canb.auug.org.au>

No problem - happy to resend!  I manually created the patch (grep; vi)
but and the result was identical :)

> at the top of the patch).  Also, you should probably mention the compile
> error that this fixes in the commit message as well.

I'll fix it and resend!

> But otherwise, thanks for submitting this.

Didn't mean to obscure authorship or the details.

Cheers!
will
