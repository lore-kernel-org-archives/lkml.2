Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934954Ab2DLWSm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 18:18:42 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:36111 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934863Ab2DLWSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 18:18:39 -0400
MIME-Version: 1.0
In-Reply-To: <1334267284-19166-7-git-send-email-wad@chromium.org>
References: <1334267284-19166-1-git-send-email-wad@chromium.org>
	<1334267284-19166-7-git-send-email-wad@chromium.org>
Date: Thu, 12 Apr 2012 15:18:34 -0700
X-Google-Sender-Auth: Jq6zqv9lyNo4bRQ-lqAitUebGvA
Message-ID: <CAGXu5j+8eyZTUUaWPPOy0s6s1PFjfpT3HjNODWdDear9ALfROg@mail.gmail.com>
Subject: Re: [PATCH v18 07/15] arch/x86: add syscall_get_arch to syscall.h
From: Kees Cook <keescook@chromium.org>
To: Will Drewry <wad@chromium.org>
Cc: linux-kernel@vger.kernel.org, linux-man@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com,
        netdev@vger.kernel.org, x86@kernel.org, arnd@arndb.de,
        davem@davemloft.net, hpa@zytor.com, mingo@redhat.com, oleg@redhat.com,
        peterz@infradead.org, rdunlap@xenotime.net, mcgrathr@chromium.org,
        tglx@linutronix.de, luto@mit.edu, eparis@redhat.com,
        serge.hallyn@canonical.com, djm@mindrot.org, scarybeasts@gmail.com,
        indan@nul.nu, pmoore@redhat.com, akpm@linux-foundation.org,
        corbet@lwn.net, eric.dumazet@gmail.com, markus@chromium.org,
        coreyb@linux.vnet.ibm.com, jmorris@namei.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2012 at 2:47 PM, Will Drewry <wad@chromium.org> wrote:
> Add syscall_get_arch() to export the current AUDIT_ARCH_* based on system call
> entry path.
>
> Signed-off-by: Will Drewry <wad@chromium.org>
> Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
> Reviewed-by: H. Peter Anvin <hpa@zytor.com>
> Acked-by: Eric Paris <eparis@redhat.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
ChromeOS Security
