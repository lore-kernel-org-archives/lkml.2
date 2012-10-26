Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028Ab2JZQsF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 12:48:05 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:35795 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370Ab2JZQsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 12:48:00 -0400
Message-ID: <508ABEBC.8060403@gmail.com>
Date: Fri, 26 Oct 2012 10:47:56 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 00/11] perf tool: Add PERF_SAMPLE_READ sample read support
References: <1350743599-4805-1-git-send-email-jolsa@redhat.com>  <87txti81i2.fsf@sejong.aot.lge.com> <1351242885.16863.0.camel@twins>  <20121026102336.GA1067@krava.brq.redhat.com>  <1351265946.1619.20.camel@leonhard>  <508AB6FC.3080904@gmail.com> <1351268730.1619.21.camel@leonhard>
In-Reply-To: <1351268730.1619.21.camel@leonhard>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/12 10:25 AM, Namhyung Kim wrote:
> 2012-10-26 (금), 10:14 -0600, David Ahern:
>> On 10/26/12 9:39 AM, Namhyung Kim wrote:
>>>> hm, thats the unique sample_type issue again ;) Once we set
>>>> PERF_SAMPLE_READ for event or group, we need to set it for
>>>> all other events in session, otherwise the report fails
>>>
>>> Sorry, I don't understand why we need to set it for all events.  Just
>>> setting it for a group is not sufficient?  Please shed some light on
>>> this.
>>
>> perf does not support multiple sample_types -- all events in the session
>> need to use the same one.
>
> Can I ask why? :)

Of course:
https://lkml.org/lkml/2011/8/15/6
https://lkml.org/lkml/2011/9/29/502

David
