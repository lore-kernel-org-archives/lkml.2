Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276Ab2GRSKS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 14:10:18 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:53352 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211Ab2GRSKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 14:10:15 -0400
MIME-Version: 1.0
In-Reply-To: <1342633133.11900.13.camel@gandalf.stny.rr.com>
References: <1342490592-20373-1-git-send-email-ccross@android.com>
	<1342633133.11900.13.camel@gandalf.stny.rr.com>
Date: Wed, 18 Jul 2012 11:10:14 -0700
X-Google-Sender-Auth: nBx7tfc1Vb9Z2uu1_gv_gq79II0
Message-ID: <CAMbhsRToTJPJuXT-rhN0cYcp2d3YjcQYL7t=4n9fn+t77TuS+Q@mail.gmail.com>
Subject: Re: [PATCH] ARM: ftrace: Trace function entry before updating index
From: Colin Cross <ccross@android.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-arm-kernel@lists.infradead.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2012 at 10:38 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Mon, 2012-07-16 at 19:03 -0700, Colin Cross wrote:
>> Commit 722b3c74695377d11d18a52f3da08114d37f3f37 modified x86 ftrace to
>> avoid tracing all functions called from irqs when function graph was
>> used with a filter.  Port the same fix to ARM.
>>
>> Cc: Steven Rostedt <rostedt@goodmis.org>
>
> Acked-by: Steven Rostedt <rostedt@goodmis.org>
>
> Someone on the ARM side needs to pull this in.
>
> I'll look into fixing this for PPC.
>
> Thanks!

Thanks, I'll put it in Russell's patch tracker.
