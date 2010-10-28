Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759398Ab0J1XZO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 19:25:14 -0400
Received: from smtp-out.google.com ([74.125.121.35]:61669 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759242Ab0J1XZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 19:25:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=mNNdbhXz0iGhtUkdOs3sp/XwcuNeQzE16SXXD1oQZGgk4mm74X1uhs3MsUJr1zxmyZ
         UKnRHilEwSAv/Kq3U/zg==
MIME-Version: 1.0
In-Reply-To: <20101028192704.GA26131@Krystal>
References: <AANLkTim8c+FLo11XJbTmTjiuucn-9UJD0Vui=fvUgCd+@mail.gmail.com>
 <AANLkTikd6sawwJeBm76QLeowXj0GBAf=wpRVgG8x5MOp@mail.gmail.com>
 <AANLkTi=Dw-dxkUgYLZYBKb5sGYcdGcpS0OH_fEHW51Jr@mail.gmail.com>
 <AANLkTi=6EBZeZ+56z_wbDuU1xTmC0saSTMDmqbqDS4Jr@mail.gmail.com> <20101028192704.GA26131@Krystal>
From: Michael Rubin <mrubin@google.com>
Date: Thu, 28 Oct 2010 16:24:46 -0700
Message-ID: <AANLkTimPTw4M7iSOna47mT06D7BvPx4__0qm71pKF62G@mail.gmail.com>
Subject: Re: Benchmarks of kernel tracing options (ftrace, ktrace, lttng and perf)
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: David Sharp <dhsharp@google.com>, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 28, 2010 at 12:27 PM, Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
> * David Sharp (dhsharp@google.com) wrote:
> Hrm, not quite fair actually. LTTng enables a thread flag that causes
> syscall_trace to be called on sycall entry/exit by default. Please try with the
> following patch to remove the extra syscall overhead.

We started this thread is an attempt to get the ball rolling on
keeping track of these metrics. They seem important for both Google
and Linux as a whole. We published all our work and benchmarks with
hopes that the owners could comment and also run the tests themselves.

Matthieu it might make more sense for you to find the" fair" setup and
publish that, than take the extra time to go back and forth with
David. Once you have the config that best represents what users will
see and you have numbers to go with it, we can then run it in our
environment. I worry you will be forced to send us patch and patch and
patch and we won't have the resources to do a good job in responding
to them. Which is not fair to you.

mrubin
