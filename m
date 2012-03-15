Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752436Ab2COEuK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 00:50:10 -0400
Received: from smarthost1.greenhost.nl ([195.190.28.78]:33010 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745Ab2COEuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 00:50:04 -0400
Message-ID: <d2e03d5f063de84d1bae3c3e06296f81.squirrel@webmail.greenhost.nl>
In-Reply-To: <1331781125-15658-12-git-send-email-wad@chromium.org>
References: <1331781125-15658-1-git-send-email-wad@chromium.org>
    <1331781125-15658-12-git-send-email-wad@chromium.org>
Date: Thu, 15 Mar 2012 05:49:47 +0100
Subject: Re: [PATCH v15 11/13] ptrace,seccomp: Add PTRACE_SECCOMP support
From: "Indan Zupancic" <indan@nul.nu>
To: "Will Drewry" <wad@chromium.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com,
        netdev@vger.kernel.org, x86@kernel.org, arnd@arndb.de,
        davem@davemloft.net, hpa@zytor.com, mingo@redhat.com, oleg@redhat.com,
        peterz@infradead.org, rdunlap@xenotime.net, mcgrathr@chromium.org,
        tglx@linutronix.de, luto@mit.edu, eparis@redhat.com,
        serge.hallyn@canonical.com, djm@mindrot.org, scarybeasts@gmail.com,
        pmoore@redhat.com, akpm@linux-foundation.org, corbet@lwn.net,
        eric.dumazet@gmail.com, markus@chromium.org, coreyb@linux.vnet.ibm.com,
        keescook@chromium.org, "Will Drewry" <wad@chromium.org>
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: -0.1
X-Scan-Signature: 4052b6d1c9976086d5ab5ce040fcf5b8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Will,

On Thu, March 15, 2012 04:12, Will Drewry wrote:
> @@ -73,6 +74,7 @@
>  #define PTRACE_EVENT_VFORK_DONE	5
>  #define PTRACE_EVENT_EXIT	6
>  #define PTRACE_EVENT_STOP	7
> +#define PTRACE_EVENT_SECCOMP	8
>
>  #include <asm/ptrace.h>
>
> @@ -101,8 +103,9 @@
>  #define PT_TRACE_EXEC		PT_EVENT_FLAG(PTRACE_EVENT_EXEC)
>  #define PT_TRACE_VFORK_DONE	PT_EVENT_FLAG(PTRACE_EVENT_VFORK_DONE)
>  #define PT_TRACE_EXIT		PT_EVENT_FLAG(PTRACE_EVENT_EXIT)
> +#define PT_TRACE_SECCOMP	PT_EVENT_FLAG(PTRACE_EVENT_SECCOMP)
>
> -#define PT_TRACE_MASK	0x000003f4
> +#define PT_TRACE_MASK	0x00000ff4

Did you miss this bit?

Greetings,

Indan


