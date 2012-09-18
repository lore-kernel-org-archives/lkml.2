Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932137Ab2IRVrK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 17:47:10 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:40136 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754865Ab2IRVrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 17:47:07 -0400
MIME-Version: 1.0
In-Reply-To: <1347499439.10751.78.camel@gandalf.local.home>
References: <1347417671-22998-1-git-send-email-dhsharp@google.com>
 <1347492720-26078-1-git-send-email-dhsharp@google.com> <1347492720-26078-3-git-send-email-dhsharp@google.com>
 <1347499439.10751.78.camel@gandalf.local.home>
From: David Sharp <dhsharp@google.com>
Date: Tue, 18 Sep 2012 14:46:43 -0700
Message-ID: <CAJL_ekvw2qsNOj1AuHQB5AOrQ+Lanv0pkr4p97-a_h-uDnXdrg@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] tracing,x86: add a TSC trace_clock
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 6:23 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> This change will require an ack from one of the x86 maintainers.
>
> For reference to this patch, please see this thread:
>
>  https://lkml.org/lkml/2012/9/11/572
>
> On Wed, 2012-09-12 at 16:31 -0700, David Sharp wrote:
>> In order to promote interoperability between userspace tracers and ftrace,
>> add a trace_clock that reports raw TSC values which will then be recorded
>> in the ring buffer. Userspace tracers that also record TSCs are then on
>> exactly the same time base as the kernel and events can be unambiguously
>> interlaced.
>>
>> Tested: Enabled a tracepoint and the "tsc" trace_clock and saw very large
>> timestamp values.
>>
>> v2:
>> Move arch-specific bits out of generic code.
>
> As Masami pointed out, please add a SOB to your patches.

Sorry about that. I guess that's what happens when I rush before going
on vacation. Apparently I did `git format-patch --signoff` the first
time instead of in the commit.
