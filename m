Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760Ab2DQDYg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 23:24:36 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61242 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030Ab2DQDYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 23:24:33 -0400
MIME-Version: 1.0
In-Reply-To: <20120417120848.e7f3eabfbf79dc609318ea1e@canb.auug.org.au>
References: <20120417120848.e7f3eabfbf79dc609318ea1e@canb.auug.org.au>
Date: Mon, 16 Apr 2012 20:24:31 -0700
X-Google-Sender-Auth: p3-JNmruorrc1GrrUw4Lk2_ecZY
Message-ID: <CAGXu5jKY+oi5PLZ33and4RX8oYQUVdpLPyswS9COK-B2Ezon4g@mail.gmail.com>
Subject: Re: [PATCH] seccomp: use a static inline for a function stub
From: Kees Cook <keescook@chromium.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: James Morris <jmorris@namei.org>, Will Drewry <wad@chromium.org>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Eric Paris <eparis@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2012 at 7:08 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Fixes this error message when CONFIG_SECCOMP is not set:
>
> arch/powerpc/kernel/ptrace.c: In function 'do_syscall_trace_enter':
> arch/powerpc/kernel/ptrace.c:1713:2: error: statement with no effect [-Werror=unused-value]
>
> Signed-off-by: Stephen Rothwell <sfr@ozlabs.au.ibm.com>

Acked-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
ChromeOS Security
