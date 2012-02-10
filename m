Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759785Ab2BJSXt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 13:23:49 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49674 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759759Ab2BJSXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 13:23:47 -0500
Message-ID: <4F3560AE.6010400@gmail.com>
Date: Fri, 10 Feb 2012 11:23:42 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
CC: Jiri Olsa <jolsa@redhat.com>, mingo@redhat.com, paulus@samba.org,
        acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org, aarapov@redhat.com
Subject: Re: [PATCHv8 0/8] ftrace, perf: Adding support to use function trace
References: <1327776209-4883-1-git-send-email-jolsa@redhat.com> <1328643899-8361-1-git-send-email-jolsa@redhat.com> <1328880444.8273.3.camel@gandalf.stny.rr.com> <1328885120.8273.7.camel@gandalf.stny.rr.com> <20120210160756.GB6145@m.redhat.com> <20120210164837.GC25516@somewhere.redhat.com> <1328896815.8273.8.camel@gandalf.stny.rr.com> <20120210180555.GD25516@somewhere.redhat.com>
In-Reply-To: <20120210180555.GD25516@somewhere.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 02/10/2012 11:05 AM, Frederic Weisbecker wrote:
> On Fri, Feb 10, 2012 at 01:00:15PM -0500, Steven Rostedt wrote:
>> On Fri, 2012-02-10 at 17:48 +0100, Frederic Weisbecker wrote:
>>
>>> Stephane Eranian has reported a similar problem but perhaps not with
>>> the same cause.
>>>
>>> I need to have a look.
>>
>> Not sure if this is related, but the "script" output of the problem
>> perf.dat file had this warning:
>>
>> Warning: Timestamp below last timeslice flush
> 
> Yup, that's what I'm looking at.

Does increasing MAX_SAMPLE_BUFFER in util/session.c help?
