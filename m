Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932529Ab2AKBFD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 20:05:03 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:44198 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932223Ab2AKBEv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 20:04:51 -0500
MIME-Version: 1.0
In-Reply-To: <008401cccff7$950164b0$bf042e10$%park@samsung.com>
References: <1326220106-5765-1-git-send-email-tj@kernel.org>
	<1326220106-5765-10-git-send-email-tj@kernel.org>
	<008401cccff7$950164b0$bf042e10$%park@samsung.com>
Date: Tue, 10 Jan 2012 17:04:50 -0800
X-Google-Sender-Auth: z3tX6kfcX2LUPfcQxQdkWtSjVLI
Message-ID: <CAOS58YM1pdw77Bz8sXuT9Jyd6pGVFs5zwnKBb4Guzxy=UdWDJg@mail.gmail.com>
Subject: Re: [PATCH 9/9] block, trace: implement ioblame - IO tracer with
 origin tracking
From: Tejun Heo <tj@kernel.org>
To: Chanho Park <chanho61.park@samsung.com>
Cc: axboe@kernel.dk, mingo@redhat.com, rostedt@goodmis.org, fweisbec@gmail.com,
        teravest@google.com, slavapestov@google.com, ctalbott@google.com,
        dhsharp@google.com, linux-kernel@vger.kernel.org, winget@google.com,
        namhyung@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Jan 10, 2012 at 4:25 PM, Chanho Park <chanho61.park@samsung.com> wrote:
>> +#define CREATE_TRACE_POINTS
>> +#include <trace/events/ioblame.h>
>
> I can't find it from patchset. So when compiling, I've got below error.
>
> CC      kernel/trace/power-traces.o
> kernel/trace/ioblame.c:308: fatal error: trace/events/ioblame.h: No such
> file or directory
> compilation terminated.
> make[2]: *** [kernel/trace/ioblame.o] Error 1
> make[2]: *** Waiting for unfinished jobs....
>
> Are you forgot to attach it or just only RFC?

Eh... crap. That's me forgetting to do quilt add. :( I'll resend shortly.

Thanks.

-- 
tejun
