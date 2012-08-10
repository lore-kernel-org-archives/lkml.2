Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757380Ab2HJQR6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 12:17:58 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:34239 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754437Ab2HJQRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 12:17:54 -0400
MIME-Version: 1.0
In-Reply-To: <1344587169-18682-1-git-send-email-alex.page.kelly@gmail.com>
References: <1344587169-18682-1-git-send-email-alex.page.kelly@gmail.com>
Date: Fri, 10 Aug 2012 09:17:52 -0700
X-Google-Sender-Auth: bukmIuv3aEdDr-u8Fco-mij_OR0
Message-ID: <CAGXu5jJ2+6qa8++7tuTMeFY9VOxj5mM97DhDp_=0oc4A3DuHYA@mail.gmail.com>
Subject: Re: [PATCHv4 1/3] fs: Move core dump functionality into its own file
From: Kees Cook <keescook@chromium.org>
To: Alex Kelly <alex.page.kelly@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Josh Triplett <josh@joshtriplett.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 10, 2012 at 1:26 AM, Alex Kelly <alex.page.kelly@gmail.com> wrote:
> This prepares for making core dump functionality optional.
>
> The variable "suid_dumpable" and associated functions are left in fs/exec.c
> because they're used elsewhere, such as in ptrace.
>
> Signed-off-by: Alex Kelly <alex.page.kelly@gmail.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> ---
> v2: This patch set is a second revision that follows some suggestions from
> Ingo Molnar and Josh Triplett. Specifically, authorship of commits is
> revised for consistency, and an additional two patches cleaning up artifacts
> and making headers more sane are added.
>
> v3: This version fixes a few more authorship issues and some problems caused
> by a bad git send-email config. Sorry about the extra mails
>
> v4: This version fixes some ordering issues pointed out by Kees Cook and Josh
> Triplett, such that the order of the functions moved to fs/coredump.c is now
> consistent with their original order in fs/exec.c. v4 also drops some extra
> blank lines unintentionally introduced in fs/coredump.c, to avoid the need to
> clean them up later. That left the cleanup patch just reformatting a comment,
> so I dropped that patch. Some of the functions moved to coredump.c need a lot
> of cleaning up, but I'm not sure that those formatting changes should be
> folded into this patch series.

Thanks for the cleanups! This looks great now.

For all three patches:
Acked-by: Kees Cook <keescook@chromium.org>

-Kees

-- 
Kees Cook
Chrome OS Security
