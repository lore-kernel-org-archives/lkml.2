Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757649Ab2FGVhU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 17:37:20 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:64252 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757444Ab2FGVhS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 17:37:18 -0400
MIME-Version: 1.0
In-Reply-To: <20120607205836.GT27374@one.firstfloor.org>
References: <20120607202355.GQ27374@one.firstfloor.org>
	<CABPqkBQ99PTsET6c_NPuioLUr_yto4x=6EBQ1K73N4ratHz48A@mail.gmail.com>
	<20120607205836.GT27374@one.firstfloor.org>
Date: Thu, 7 Jun 2012 23:37:16 +0200
Message-ID: <CABPqkBQ1qHn-OaxcB_hde0BO7fWsyvaQ8WqxSBBHcghqkjnm0Q@mail.gmail.com>
Subject: Re: perf user tool precise attribute broken in 3.5rc1+
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: acme@redhat.com, jolsa@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 7, 2012 at 10:58 PM, Andi Kleen <andi@firstfloor.org> wrote:
> On Thu, Jun 07, 2012 at 10:53:19PM +0200, Stephane Eranian wrote:
>> On Thu, Jun 7, 2012 at 10:23 PM, Andi Kleen <andi@firstfloor.org> wrote:
>> >
>> > With a perf user tool compiled from a 3.5rc1+ kernel I cannot
>> > use the 'p' attribute anymore. Always get
>> >
>> > ak@petrock:~> ./perf record -e cycles:p ./t
>> >
>> >  Error: sys_perf_event_open() syscall returned with 22 (Invalid argument).  /bin/dmesg may provide additional information.
>> >
>> >  Fatal: No CONFIG_PERF_EVENTS=y kernel support configured?
>> >
>> Remember that PEBS is disabled on SNB unless you have the new ucode + my patch.
>
> This is not the problem. This was actually a -E where it was not disabled
> in my tree.  And the older perf binary works, so it's clearly not a kernel
> problem.

What's -E?

>
> -Andi
