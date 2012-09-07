Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031Ab2IGQg3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 12:36:29 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:56380 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755413Ab2IGQgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 12:36:12 -0400
MIME-Version: 1.0
In-Reply-To: <1346899577.1680.11.camel@gandalf.local.home>
References: <1345204994-5400-1-git-send-email-elezegarcia@gmail.com>
	<1345217308.3708.35.camel@gandalf.local.home>
	<CALF0-+WGTLQJQ-k3s11BjwpDnpJqByQuLEPttan+n4ecs2MQ5g@mail.gmail.com>
	<1346867590.27919.60.camel@gandalf.local.home>
	<1346899577.1680.11.camel@gandalf.local.home>
Date: Fri, 7 Sep 2012 13:36:11 -0300
Message-ID: <CALF0-+XBTtAXQSaFvOQPTcNYKeKosenxu9tTsnCr1DFUXqOw6w@mail.gmail.com>
Subject: Re: [RFC PATCH v2] trace: Move trace event enable from fs_initcall to early_initcall
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, tim.bird@am.sony.com,
        lizefan@huawei.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

On Wed, Sep 5, 2012 at 11:46 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Wed, 2012-09-05 at 13:53 -0400, Steven Rostedt wrote:
>> On Tue, 2012-09-04 at 22:18 -0300, Ezequiel Garcia wrote:
>> > Hi Steven,
>> >
>> > On 8/17/12, Steven Rostedt <rostedt@goodmis.org> wrote:
>> > > On Fri, 2012-08-17 at 09:03 -0300, Ezequiel Garcia wrote:
>> > >> This patch splits trace event initialization in two stages:
>> > >>  * ftrace enable
>> > >>  * sysfs event entry creation
>> > >>
>> > >> This allows to capture trace events from an earlier point
>> > >> by using 'trace_event' kernel parameter and is important
>> > >> to trace boot-up allocations.
>> > >>
>> > >
>> > > This is much better, I'll give it some tests and add it to my 3.7 queue.
>> > >
>> >
>> > Ping? Will you add this to your tree?
>>
>> Yeah, I haven't been able to test it yet. I've been stuck trying to
>> figure out bugs on other patches I have queued. I'll let you know when I
>> do apply it though.
>
> Just tested it and it failed :-/
>

Damn!

> Enable CONFIG_FTRACE_SELFTEST and CONFIG_FTRACE_STARTUP_TEST, along with
> events and syscall events. The syscall event self test fails with this
> patch applied.
>

Ok, I'll resend a v3.

Sorry for not testing this myself and thanks,
Ezequiel.
