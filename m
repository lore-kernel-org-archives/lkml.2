Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755971Ab2JPUC7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 16:02:59 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:42686 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755795Ab2JPUC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 16:02:58 -0400
MIME-Version: 1.0
In-Reply-To: <6469.1350392031@warthog.procyon.org.uk>
References: <1349998076-15495-1-git-send-email-dhsharp@google.com>
 <1349998076-15495-2-git-send-email-dhsharp@google.com> <CAMuHMdVx5PU--fo+J1c04qcdG6r+B1DJwD6cxR8evFAyVpJBHQ@mail.gmail.com>
 <CAJL_ektJgQayiTPAkxxaT3TZLuUCjo2UsFuhMuxCsp-DFVqjFQ@mail.gmail.com> <6469.1350392031@warthog.procyon.org.uk>
From: David Sharp <dhsharp@google.com>
Date: Tue, 16 Oct 2012 13:02:36 -0700
Message-ID: <CAJL_ektjV5SxmHaa+=Rjdu6nVxhUviALq-oSLs5qitCqZJspMw@mail.gmail.com>
Subject: Re: [PATCH v6 1/6] tracing,x86: Add a TSC trace_clock
To: David Howells <dhowells@redhat.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2012 at 5:53 AM, David Howells <dhowells@redhat.com> wrote:
> David Sharp <dhsharp@google.com> wrote:
>
>> > Please use the Kbuild infrastructure ("generic-y += ..." in
>> > arch/*/include/asm/Kbuild)
>> > instead of adding wrappers around the asm-generic version.
>>
>> mips apparently recencly got rid of arch/mips/include/asm/Kbuild.
>
> It didn't.  However, if you use patch to create your kernel tree, then patch
> may have removed it.  If you're using GIT, it should still exist.  Try:

Ah, right. It's not missing, just empty.

>
>         git log -- arch/mips/include/asm/Kbuild
>
>> What should I do for mips?
>
> Just create the file with a single "generic-y += ..." line in it.

Okay. Thanks.

>
> David
