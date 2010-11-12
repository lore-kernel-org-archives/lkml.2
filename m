Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932355Ab0KLPB5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 10:01:57 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:62629 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932100Ab0KLPB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 10:01:56 -0500
Message-ID: <4CDD56E3.5030303@dcl.info.waseda.ac.jp>
Date: Sat, 13 Nov 2010 00:01:55 +0900
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100724 Lanikai/3.1.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, h.mitake@gmail.com,
        Ma Ling <ling.ma@intel.com>, Zhao Yakui <yakui.zhao@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 2/2] perf bench: add x86-64 specific benchmarks to perf
 bench mem memcpy
References: <1288368098-26121-1-git-send-email-mitake@dcl.info.waseda.ac.jp> <1288368098-26121-2-git-send-email-mitake@dcl.info.waseda.ac.jp> <20101030192357.GC26503@elte.hu> <4CCE51E6.7060908@dcl.info.waseda.ac.jp> <20101101090251.GA28039@elte.hu> <4CD43975.1000300@dcl.info.waseda.ac.jp> <20101110091217.GD8370@elte.hu>
In-Reply-To: <20101110091217.GD8370@elte.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010年11月10日 18:12, Ingo Molnar wrote:
>
> * Hitoshi Mitake<mitake@dcl.info.waseda.ac.jp>  wrote:
>
>>> An even better solution would be to output _both_ results by default, so that
>>> people can see both characteristics at a glance?
>>
>> Outputting both result of prefaulted and non prefaulted will be useful, but this
>> might be not good for using from scripts. So I'll implement --prefault option
>> first. If there is request for outputting both, I'll consider to modify default
>> output.
>
> Ok - it should definitely be easily scriptable. The default can be have both flags
> enabled and both results written to the output.
>
> People will try 'perf bench x86' to see performance at a glance - so printing all
> the tests we have is a good idea.

OK, I added --no-prefault and --only-prefault to perf bench mem memcpy.
As you told, printing both of them is convenient.

I send the updated patch later.

Thanks,
