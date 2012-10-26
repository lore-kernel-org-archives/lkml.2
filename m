Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965240Ab2JZQO5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 12:14:57 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52777 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965038Ab2JZQO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 12:14:56 -0400
Message-ID: <508AB6FC.3080904@gmail.com>
Date: Fri, 26 Oct 2012 10:14:52 -0600
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
References: <1350743599-4805-1-git-send-email-jolsa@redhat.com>  <87txti81i2.fsf@sejong.aot.lge.com> <1351242885.16863.0.camel@twins>  <20121026102336.GA1067@krava.brq.redhat.com> <1351265946.1619.20.camel@leonhard>
In-Reply-To: <1351265946.1619.20.camel@leonhard>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/12 9:39 AM, Namhyung Kim wrote:
>> hm, thats the unique sample_type issue again ;) Once we set
>> PERF_SAMPLE_READ for event or group, we need to set it for
>> all other events in session, otherwise the report fails
>
> Sorry, I don't understand why we need to set it for all events.  Just
> setting it for a group is not sufficient?  Please shed some light on
> this.

perf does not support multiple sample_types -- all events in the session 
need to use the same one.

David

