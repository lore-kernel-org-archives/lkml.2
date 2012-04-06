Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828Ab2DFAY7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 20:24:59 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:35326 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389Ab2DFAY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 20:24:57 -0400
Message-ID: <4F7E37D4.1050205@gmail.com>
Date: Thu, 05 Apr 2012 18:24:52 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <srostedt@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, Jiri Olsa <jolsa@redhat.com>,
        Arun Sharma <asharma@fb.com>, Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 02/15] tools/events: Add files to create libtraceevent.a
References: <1333666086-6517-1-git-send-email-fweisbec@gmail.com>  <1333666086-6517-3-git-send-email-fweisbec@gmail.com>  <4F7E33F6.7050309@gmail.com> <1333671536.3764.76.camel@pippen.local.home>
In-Reply-To: <1333671536.3764.76.camel@pippen.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/5/12 6:18 PM, Steven Rostedt wrote:
> On Thu, 2012-04-05 at 18:08 -0600, David Ahern wrote:
>
>>
>> I found that this lib needs to be an .so to work with trace-cmd's plugins.
>>
>
> And not just trace-cmd. I want to get those plugins to also work with
> perf. That is, have the kvm plugin (et. al.) make it so that perf does
> not need to rely only on the TP_printk() in the format file.
>
> But that said, it is trivial to make this into a .so. Just having a
> separate library would be a huge first step.

Right, I meant to get trace-cmd's plugins to work with perf.

I have a patch that applies to your set from last August for that 
purpose; it applies to Frederic's version just working on a header file 
name collision. I've been using the plugins-modified perf specifically 
for kvm events.

David
