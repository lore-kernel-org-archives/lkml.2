Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781Ab2JLCcT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 22:32:19 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:56358 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969Ab2JLCcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 22:32:17 -0400
MIME-Version: 1.0
In-Reply-To: <1350007016.24256.82.camel@gandalf.local.home>
References: <1339112785-21806-1-git-send-email-vnagarnaik@google.com> <1350007016.24256.82.camel@gandalf.local.home>
From: David Sharp <dhsharp@google.com>
Date: Thu, 11 Oct 2012 19:31:55 -0700
Message-ID: <CAJL_ektrdqwBoUYj9yoXn8FUaY7n+FmsVKHaosZtcX9yhobeHg@mail.gmail.com>
Subject: Re: [PATCH 1/2] tracing: trivial cleanup
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Vaibhav Nagarnaik <vnagarnaik@google.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2012 at 6:56 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> Sorry, I know this is late, but it was pushed down in my todo list
> (never off, but something I probably wouldn't have seen for a few more
> months).
>
> On Thu, 2012-06-07 at 16:46 -0700, Vaibhav Nagarnaik wrote:
>> From: David Sharp <dhsharp@google.com>
>
> If this is from David it needs his SOB.

Is that true even though we are working for the same company?

> -- Steve
>
>>
>> Remove ftrace_format_syscall() declaration; it is neither defined nor
>> used. Also update a comment and formatting.
>>
>> Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>

Signed-off-by: David Sharp <dhsharp@google.com>

>> ---
>>  include/trace/syscall.h    |    2 --
>>  kernel/trace/ring_buffer.c |    6 +++---
>>  2 files changed, 3 insertions(+), 5 deletions(-)
>>
>> diff --git a/include/trace/syscall.h b/include/trace/syscall.h
>> index 31966a4..0c95796 100644
>> --- a/include/trace/syscall.h
>> +++ b/include/trace/syscall.h
>> @@ -39,8 +39,6 @@ extern int reg_event_syscall_enter(struct ftrace_event_call *call);
>>  extern void unreg_event_syscall_enter(struct ftrace_event_call *call);
>>  extern int reg_event_syscall_exit(struct ftrace_event_call *call);
>>  extern void unreg_event_syscall_exit(struct ftrace_event_call *call);
>> -extern int
>> -ftrace_format_syscall(struct ftrace_event_call *call, struct trace_seq *s);
>>  enum print_line_t print_syscall_enter(struct trace_iterator *iter, int flags,
>>                                     struct trace_event *event);
>>  enum print_line_t print_syscall_exit(struct trace_iterator *iter, int flags,
>> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
>> index 1d0f6a8..96c2dd1 100644
>> --- a/kernel/trace/ring_buffer.c
>> +++ b/kernel/trace/ring_buffer.c
>> @@ -1816,7 +1816,7 @@ rb_add_time_stamp(struct ring_buffer_event *event, u64 delta)
>>  }
>>
>>  /**
>> - * ring_buffer_update_event - update event type and data
>> + * rb_update_event - update event type and data
>>   * @event: the even to update
>>   * @type: the type of event
>>   * @length: the size of the event field in the ring buffer
>> @@ -2716,8 +2716,8 @@ EXPORT_SYMBOL_GPL(ring_buffer_discard_commit);
>>   * and not the length of the event which would hold the header.
>>   */
>>  int ring_buffer_write(struct ring_buffer *buffer,
>> -                     unsigned long length,
>> -                     void *data)
>> +                   unsigned long length,
>> +                   void *data)
>>  {
>>       struct ring_buffer_per_cpu *cpu_buffer;
>>       struct ring_buffer_event *event;
>
>
