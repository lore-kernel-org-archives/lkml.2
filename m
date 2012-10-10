Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756482Ab2JJNoM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 09:44:12 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:35631 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754675Ab2JJNoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 09:44:07 -0400
MIME-Version: 1.0
In-Reply-To: <20121010134020.GA14897@krava.brq.redhat.com>
References: <1349873598-12583-1-git-send-email-jolsa@redhat.com>
	<CABPqkBQ8SS790ynd8tdjUk1fKwKN0UdqApJ_p4JvbgyyRU48Uw@mail.gmail.com>
	<20121010134020.GA14897@krava.brq.redhat.com>
Date: Wed, 10 Oct 2012 15:44:05 +0200
Message-ID: <CABPqkBQpFV0yAe4atbMSDhfqdN9XAQWwJujubSQJ=b+_XGjLag@mail.gmail.com>
Subject: Re: [PATCHv4 0/8] perf, tool: Allow to use hw events in PMU syntax
From: Stephane Eranian <eranian@google.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 10, 2012 at 3:40 PM, Jiri Olsa <jolsa@redhat.com> wrote:
> On Wed, Oct 10, 2012 at 03:34:53PM +0200, Stephane Eranian wrote:
>> On Wed, Oct 10, 2012 at 2:53 PM, Jiri Olsa <jolsa@redhat.com> wrote:
>> > hi,
>> > here's the change to make following syntax available:
>> >   perf stat -e cpu/event=instructions/u ls
>> >   perf stat -e cpu/cycles/u ls
>> >
>> Unless, I am mistaken but I did not see in your patch where you adjust the list
>> of generic Hw events (and encodings) you expose via sysfs based on CPU model
>> number. Some generic HW PMU may not have actual physical mappings. Look
>> at IvyBridge, for instance.
>
> hm, path 2 remove any attribute that is not defined via x86_pmu.event_map,
> if that's what you mean..
>
Ok, you're right, so this should be okay then.
Thanks.

> jirka
