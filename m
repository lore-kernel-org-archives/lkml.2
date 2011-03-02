Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756525Ab1CBJuc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 04:50:32 -0500
Received: from mail-gw0-f51.google.com ([74.125.83.51]:36203 "EHLO
	mail-gw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756358Ab1CBJua convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 04:50:30 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1103021033260.2701@localhost6.localdomain6>
References: <AANLkTi=WRo41JprvcEH0Lgc_-j_bTX1MULgJFShV6W9g@mail.gmail.com>
	<alpine.LFD.2.00.1103021033260.2701@localhost6.localdomain6>
Date: Wed, 2 Mar 2011 10:50:29 +0100
Message-ID: <AANLkTikzfNsB=9jQSYrWDEYd3Kd1-d8cVMO79ZqDNt4n@mail.gmail.com>
Subject: Re: [PATCH V6 2/2] tracing, perf: add cpu hotplug trace events
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-hotplug@vger.kernel.org,
        fweisbec@gmail.com, rostedt@goodmis.org, amit.kucheria@linaro.org,
        mingo@elte.hu, rusty@rustcorp.com.au
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2 March 2011 10:38, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Tue, 1 Mar 2011, Vincent Guittot wrote:
>
>> Trace the cpu state and the time spent in core and arch code
>
> So you completely ignored my review comments, except for fixing up the
> changelog.
>
>        https://lkml.org/lkml/2011/2/24/297
>
> All of the comments in the code still apply and either you fix it or
> at least have the courtesy to explain why you think that those
> comments do not need to be addressed.
>

I thought that I have answered to your comments :
https://lkml.org/lkml/2011/2/28/203

Do I miss something ?

Thanks,

Vincent
> Thanks,
>
>        tglx
>
