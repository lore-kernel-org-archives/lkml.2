Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512Ab1HWNcP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 09:32:15 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45423 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754917Ab1HWNbw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 09:31:52 -0400
MIME-Version: 1.0
In-Reply-To: <1314105839.8002.51.camel@twins>
References: <CAELBVzAXXjfHDkUxSVM39coDC1QyNBtDc-gW27a-yascs2nVuA@mail.gmail.com>
	<1314105839.8002.51.camel@twins>
Date: Tue, 23 Aug 2011 10:31:50 -0300
Message-ID: <CAELBVzBO7VcXG=A=hey3-GsbCPvUZtBfPSFdjidzTqEmMg__iA@mail.gmail.com>
Subject: =?windows-1252?Q?Re=3A_warning=3A_=91x86=5Fget=5Fevent=5Fconstraints=92_defined?=
	=?windows-1252?Q?_but_not_used?=
From: Kevin Winchester <kjwinchester@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: acme@ghostprotocols.net, mingo@elte.hu, x86@kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 August 2011 10:23, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Mon, 2011-08-15 at 20:40 -0300, Kevin Winchester wrote:
>> Is there are reason why those C
>> files are included directly in another C file rather than being linked
>> together?
>
> Sheer suckyness on my part.. we needed a 'quick' fix to make these
> CPU_SUP_* things build at all and never got around to cleaning it up
> afterwards.
>
>> Or is there some other way the code could be improved and
>> also remove the warning at the same time?
>
> creation of a arch/x86/kernel/cpu/perf_event.h and enough code massage
> to make all these .c files compile independently would be appreciated,
> not sure that'll immediately solve your issue though.
>
>> I do not mind doing some coding here to make this happen.  I am very
>> close to a warning-free build, so I would definitely like to take care
>> of this one.
>
> You could slip something like it into the 'cleanup' if nothing else
> presents itself :-)
>

Sure, I'll give the above suggestion a try and see if I can ensure
that the function is not compiled unless it is needed.

Kevin
