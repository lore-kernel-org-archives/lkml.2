Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964899Ab2JWUfi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:35:38 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:50157 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964803Ab2JWUfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:35:31 -0400
MIME-Version: 1.0
In-Reply-To: <1351022666-6960-158-git-send-email-keescook@chromium.org>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org> <1351022666-6960-158-git-send-email-keescook@chromium.org>
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Tue, 23 Oct 2012 21:35:10 +0100
X-Google-Sender-Auth: 49GkG4Mjv2nOF5PYfkiEz_vu-h8
Message-ID: <CAHkRjk5u-OdVr-rhAToZJJEi7sKjq3ibxt_9BmoqjRo2FOWhzw@mail.gmail.com>
Subject: Re: [PATCH 157/193] lib: remove CONFIG_EXPERIMENTAL
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        James Morris <james.l.morris@oracle.com>,
        "Darrick J. Wong" <djwong@us.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Akinobu Mita <akinobu.mita@gmail.com>, Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 October 2012 21:03, Kees Cook <keescook@chromium.org> wrote:
> This config item has not carried much meaning for a while now and is
> almost always enabled by default. As agreed during the Linux kernel
> summit, remove it.
>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: "Paul E. McKenney" <paul.mckenney@linaro.org>
> CC: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
> CC: James Morris <james.l.morris@oracle.com>
> CC: "Darrick J. Wong" <djwong@us.ibm.com>
> CC: "Michael S. Tsirkin" <mst@redhat.com>
> CC: Akinobu Mita <akinobu.mita@gmail.com>
> CC: Ingo Molnar <mingo@kernel.org>
> CC: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Kees Cook <keescook@chromium.org>
...
>  config DEBUG_KMEMLEAK
>         bool "Kernel memory leak detector"
> -       depends on DEBUG_KERNEL && EXPERIMENTAL && HAVE_DEBUG_KMEMLEAK
> +       depends on DEBUG_KERNEL && HAVE_DEBUG_KMEMLEAK
>         select DEBUG_FS
>         select STACKTRACE if STACKTRACE_SUPPORT
>         select KALLSYMS

For the kmemleak part:

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
