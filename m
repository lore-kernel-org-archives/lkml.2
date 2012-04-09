Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151Ab2DITql (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 15:46:41 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37882 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081Ab2DITqj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 15:46:39 -0400
MIME-Version: 1.0
In-Reply-To: <20120406142644.223ffff0.akpm@linux-foundation.org>
References: <1333051320-30872-1-git-send-email-wad@chromium.org>
	<1333051320-30872-16-git-send-email-wad@chromium.org>
	<20120406142644.223ffff0.akpm@linux-foundation.org>
Date: Mon, 9 Apr 2012 14:46:34 -0500
Message-ID: <CABqD9haT5h-7LMkbGSaQbnk8SJj9L21GT61UZCMVWLJCTw9OBg@mail.gmail.com>
Subject: Re: [PATCH v17 15/15] Documentation: prctl/seccomp_filter
From: Will Drewry <wad@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
        kernel-hardening@lists.openwall.com, netdev@vger.kernel.org,
        x86@kernel.org, arnd@arndb.de, davem@davemloft.net, hpa@zytor.com,
        mingo@redhat.com, oleg@redhat.com, peterz@infradead.org,
        rdunlap@xenotime.net, mcgrathr@chromium.org, tglx@linutronix.de,
        luto@mit.edu, eparis@redhat.com, serge.hallyn@canonical.com,
        djm@mindrot.org, scarybeasts@gmail.com, indan@nul.nu,
        pmoore@redhat.com, corbet@lwn.net, eric.dumazet@gmail.com,
        markus@chromium.org, coreyb@linux.vnet.ibm.com, keescook@chromium.org,
        jmorris@namei.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 6, 2012 at 4:26 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Thu, 29 Mar 2012 15:02:00 -0500
> Will Drewry <wad@chromium.org> wrote:
>
>> Documents how system call filtering using Berkeley Packet
>> Filter programs works and how it may be used.
>> Includes an example for x86 and a semi-generic
>> example using a macro-based code generator.
>>
>>
>> ...
>>
>> +Adding architecture support
>> +-----------------------
>> +
>> +See arch/Kconfig for the authoritative requirements.  In general, if an
>> +architecture supports both ptrace_event and seccomp, it will be able to
>> +support seccomp filter with minor fixup: SIGSYS support and seccomp return
>> +value checking.  Then it must just add CONFIG_HAVE_ARCH_SECCOMP_FILTER
>> +to its arch-specific Kconfig.
>> diff --git a/samples/Makefile b/samples/Makefile
>> index 2f75851..5ef08bb 100644
>> --- a/samples/Makefile
>> +++ b/samples/Makefile
>
> Oh good, I was going to ask about that.
>
> Can we get this code into tools/testing/selftests?  That way people
> will run it more often and it's more likely to be maintained as the
> code evolves.

I'm currently using a lightweight testsuite in addition to the
samples.  It's a little more oriented at pass/fail behavior.  Would it
be more appropriate to post those in addition to, or instead of,
samples?

thanks!
