Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234Ab3AFB5M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 20:57:12 -0500
Received: from mail-qc0-f181.google.com ([209.85.216.181]:50536 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754915Ab3AFB5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 20:57:11 -0500
X-Greylist: delayed 375 seconds by postgrey-1.27 at vger.kernel.org; Sat, 05 Jan 2013 20:57:11 EST
From: Sadasivan Shaiju <sshaiju@mvista.com>
References: <aba006370d1e788a3ff0612afca6d3e7@mail.gmail.com> <20130105172116.GA65150@digium.com>
In-Reply-To: <20130105172116.GA65150@digium.com>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQKp3EkhtONpmgJJol3fN1OCX6VI0AGtVi4QlnY89xA=
Date: Sat, 5 Jan 2013 17:50:54 -0800
Message-ID: <3accb98298ac0ccdbfa1930938febfa6@mail.gmail.com>
Subject: RE: Incorrect accounting of irq into the running task
To: Shaun Ruffell <sruffell@digium.com>
Cc: linux-kernel@vger.kernel.org, venki@google.com, a.p.zijlstra@chello.nl
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shaun,

-----Original Message-----
From: Shaun Ruffell [mailto:sruffell@digium.com]
Sent: Saturday, January 05, 2013 9:21 AM
To: Sadasivan Shaiju
Cc: linux-kernel@vger.kernel.org; venki@google.com; a.p.zijlstra@chello.nl
Subject: Re: Incorrect accounting of irq into the running task

On Fri, Jan 04, 2013 at 10:22:12AM -0800, Sadasivan Shaiju wrote:
> Hi  Venkatesh,
>
> I have applied the following patches for the incorrect accounting of
> irq into the running task .
>
>
> [PATCH] x86: Add IRQ_TIME_ACCOUNTING
> [e82b8e4ea4f3dffe6e7939f90e78da675fcc450e]
> [PATCH] sched: Add IRQ_TIME_ACCOUNTING, finer accounting of irq time
> [b52bfee445d315549d41eacf2fa7c156e7d153d5]
>
> [PATCH] sched: Do not account irq time to current task
> [305e6835e05513406fa12820e40e4a8ecb63743c]
> [PATCH] sched: Export ns irqtimes through /proc/stat
> [abb74cefa9c682fb38ba86c17ca3c86fed6cc464]
>
>
>
> But still the stime and utime of the process in /proc/pid/stat is
> high. I think the above patches does not update The stime and utime
> values in /proc/pid/stat.
>
>
> Or am I missing anything?

Just checking that you do have CONFIG_IRQ_TIME_ACCOUNTING=y in your kernel
config?

  Yes  it  is  turned  on  .

Regards,
Shaiju.

Cheers,
Shaun
