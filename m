Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563Ab1GEQUl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 12:20:41 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:37245 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749Ab1GEQUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 12:20:40 -0400
MIME-Version: 1.0
In-Reply-To: <1309870284.26417.172.camel@gandalf.stny.rr.com>
References: <20110702030435.308336775@goodmis.org> <20110702033853.220897627@goodmis.org>
 <CAMjpGUd2rqVSXVvRYbXW_-ah-91pYntKGxwrjXKqBeN27QUVLQ@mail.gmail.com> <1309870284.26417.172.camel@gandalf.stny.rr.com>
From: Mike Frysinger <vapier@gentoo.org>
Date: Tue, 5 Jul 2011 12:20:20 -0400
X-Google-Sender-Auth: SqkpkPTJ4-lZ3lQuyj8GAbSX_Qk
Message-ID: <CAMjpGUeRhJ6m4wFs1xjBFTCaJoy5xQRg8s694CW+nP7wMPQxHQ@mail.gmail.com>
Subject: Re: [patch 03/11] blackfin/irqs: Do not trace arch_local_{*,irq_*} functions
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 5, 2011 at 08:51, Steven Rostedt wrote:
> On Sat, 2011-07-02 at 12:40 -0400, Mike Frysinger wrote:
>> On Fri, Jul 1, 2011 at 23:04, Steven Rostedt wrote:
>> > Do not trace arch_local_save_flags(), arch_local_irq_*() and friends.
>> > Although they are marked inline, gcc may still make a function out of
>> > them and add it to the pool of functions that are traced by the function
>> > tracer. This can cause undesirable results (kernel panic, triple faults,
>> > etc).
>> >
>> > Add the notrace notation to prevent them from ever being traced.
>>
>> Acked-by: Mike Frysinger <vapier@gentoo.org>
>
> Thanks! Are you going to pull it into the blackfin tree? It's not
> dependent on any other patch.

in that case, i'll merge it
-mike
