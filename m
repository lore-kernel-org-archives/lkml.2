Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835Ab2GXRlJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 13:41:09 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:35647 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755255Ab2GXRlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 13:41:07 -0400
MIME-Version: 1.0
In-Reply-To: <1343143742-31229-1-git-send-email-tixxdz@opendz.org>
References: <1343143742-31229-1-git-send-email-tixxdz@opendz.org>
Date: Tue, 24 Jul 2012 10:41:06 -0700
X-Google-Sender-Auth: tB7H4enq4OonMR3fFJKnfDFRGhA
Message-ID: <CAGXu5jJTJ2uz-GGCXhHtUnGiZy=ChXVWYey8d2XTa4gZjJ7w2w@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] proc: /proc/<pid>/environ offset fixes
From: Kees Cook <keescook@chromium.org>
To: Djalal Harouni <tixxdz@opendz.org>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vasiliy Kulikov <segoon@openwall.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        Solar Designer <solar@openwall.com>,
        David Rientjes <rientjes@google.com>,
        Brad Spengler <spender@grsecurity.net>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jul 24, 2012 at 8:29 AM, Djalal Harouni <tixxdz@opendz.org> wrote:
> This is the V2 to correctly check offsets on /proc/<pid>/environ before
> reading. This was previously discussed here:
> http://lkml.org/lkml/2012/7/22/79
>
> Due to incorrect offset checks, currently one can read from aribtrary
> addresses on /proc/<pid>/environ, not only the environment address range
> as shown here (the same thread):
> http://lkml.org/lkml/2012/7/22/163
>
> The bug is in environ_read().
> [...]
> Djalal Harouni (2):
>   proc: environ_read() make sure offset points to environment address range
>   proc: do not allow negative offsets on /proc/<pid>/environ
>
>  fs/proc/base.c |   22 +++++++++++++---------
>   1 files changed, 13 insertions(+), 9 deletions(-)

This looks good, thanks!

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

-- 
Kees Cook
Chrome OS Security
