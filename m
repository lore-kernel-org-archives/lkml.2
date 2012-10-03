Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965350Ab2JCQZS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 12:25:18 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:47216 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932772Ab2JCQZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 12:25:14 -0400
MIME-Version: 1.0
In-Reply-To: <506C4F29.4090303@gmail.com>
References: <E1T1N2q-0001xm-5X@morero.ard.nu>
	<20120820180037.GV4232@outflux.net>
	<CAKFga-dDRyRwxUu4Sv7QLcoyY5T3xxhw48LP2goWs=avGW0d_A@mail.gmail.com>
	<CAGXu5jJCqABZcMHuQNAaAcUKCEsSqOTn5=DHdwFdJ70zVLsmSQ@mail.gmail.com>
	<CAKFga-fB2JSAscSVi+YUOnFS4Lq4yzH5MHRwxDQBQYZfKAgB6A@mail.gmail.com>
	<CAGXu5jLj6qm+Rv3v2pmJqfEmhZBkKJsMUe0aRqxSa=s=w4wbDw@mail.gmail.com>
	<20121002153841.a03ad73b.akpm@linux-foundation.org>
	<alpine.LSU.2.00.1210021733580.1343@eggly.anvils>
	<506C4F29.4090303@gmail.com>
Date: Wed, 3 Oct 2012 09:25:13 -0700
X-Google-Sender-Auth: MvUKrDxg0aliz41dV6_TwjaXdsg
Message-ID: <CAGXu5j+tbnvHrDPEbQZwHkVyat+HiroDf4FeW8HB7gwqpaO65g@mail.gmail.com>
Subject: Re: Updated: [PATCH] hardening: add PROT_FINAL prot flag to mmap/mprotect
From: Kees Cook <keescook@chromium.org>
To: Ard Biesheuvel <ard.biesheuvel@gmail.com>
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 3, 2012 at 7:43 AM, Ard Biesheuvel <ard.biesheuvel@gmail.com> wrote:
> This patch adds support for the PROT_FINAL flag to
> the mmap() and mprotect() syscalls.
>
> The PROT_FINAL flag indicates that the requested set
> of protection bits should be final, i.e., it shall
> not be allowed for a subsequent mprotect call to
> set protection bits that were not set already.
>
> This is mainly intended for the dynamic linker,
> which sets up the address space on behalf of
> dynamic binaries. By using this flag, it can
> prevent exploited code from remapping read-only
> executable code or data sections read-write.
>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@gmail.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

If it wasn't clear before, I like this idea. :)

-Kees

-- 
Kees Cook
Chrome OS Security
