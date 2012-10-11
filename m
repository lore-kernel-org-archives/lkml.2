Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285Ab2JKXab (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 19:30:31 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:56137 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898Ab2JKXa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 19:30:29 -0400
MIME-Version: 1.0
In-Reply-To: <50738708.1020900@hitachi.com>
References: <1349148680-9509-1-git-send-email-dhsharp@google.com> <50738708.1020900@hitachi.com>
From: David Sharp <dhsharp@google.com>
Date: Thu, 11 Oct 2012 16:30:07 -0700
Message-ID: <CAJL_ekuSbPDDLbJy3b5k3iMEejZv=_CJUYM2anrUEOhQEqNsjQ@mail.gmail.com>
Subject: Re: [PATCH v5 1/3] tracing,x86: Add a TSC trace_clock
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 8, 2012 at 7:08 PM, Yoshihiro YUNOMAE
<yoshihiro.yunomae.ez@hitachi.com> wrote:
> Hi David,
>
> This is a nice patch set.
>
> I just have found something should be fixed, which related to
> your work. I'll send it following this mail.
>
> Would you mind adding these patches as your patch series?

Thanks for noticing the stats issue. Added them to my series.

>
> Thanks,
>
> Yoshihiro YUNOMAE
>
> (2012/10/02 12:31), David Sharp wrote:
>> In order to promote interoperability between userspace tracers and ftrace,
>> add a trace_clock that reports raw TSC values which will then be recorded
>> in the ring buffer. Userspace tracers that also record TSCs are then on
>> exactly the same time base as the kernel and events can be unambiguously
>> interlaced.
>>
>
> --
> Yoshihiro YUNOMAE
> Software Platform Research Dept. Linux Technology Center
> Hitachi, Ltd., Yokohama Research Laboratory
> E-mail: yoshihiro.yunomae.ez@hitachi.com
>
>
