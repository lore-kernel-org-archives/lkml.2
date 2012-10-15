Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492Ab2JOTFb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 15:05:31 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:33167 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628Ab2JOTFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 15:05:30 -0400
MIME-Version: 1.0
In-Reply-To: <1350042118.24256.93.camel@gandalf.local.home>
References: <1349998076-15495-1-git-send-email-dhsharp@google.com>
 <1349998076-15495-2-git-send-email-dhsharp@google.com> <CAMuHMdVx5PU--fo+J1c04qcdG6r+B1DJwD6cxR8evFAyVpJBHQ@mail.gmail.com>
 <1350042118.24256.93.camel@gandalf.local.home>
From: David Sharp <dhsharp@google.com>
Date: Mon, 15 Oct 2012 12:05:08 -0700
Message-ID: <CAJL_eks6dbXZa28e2me1P3V07zqWGp57WPqQTBp55e6onkPVfQ@mail.gmail.com>
Subject: Re: [PATCH v6 1/6] tracing,x86: Add a TSC trace_clock
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2012 at 4:41 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Fri, 2012-10-12 at 07:05 +0200, Geert Uytterhoeven wrote:
>> On Fri, Oct 12, 2012 at 1:27 AM, David Sharp <dhsharp@google.com> wrote:
>> > +#include <asm-generic/trace_clock.h>
>>
>> Please use the Kbuild infrastructure ("generic-y += ..." in
>> arch/*/include/asm/Kbuild)
>> instead of adding wrappers around the asm-generic version.
>
> So that's how that's done. Learn something new everyday. Too bad the one
> file I checked (div64.h) doesn't seem to do it for ia64 and others.
>
> Can we please have someone clean up all the archs and remove any *.h
> wrappers and use the kbuild infrastructure instead. That way, when
> another developer goes to look at how this is done, they wont copy the
> wrong method again. (Maybe I'll just do it :-p)
>
> David,
>
> Can you just send an update of this one patch.

Will do. Thanks for the education, Geert. :)

d#
