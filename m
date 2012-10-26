Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933646Ab2JZPHA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 11:07:00 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:50637 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932078Ab2JZPG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 11:06:57 -0400
Message-ID: <508AA709.7010202@gmail.com>
Date: Fri, 26 Oct 2012 09:06:49 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Andrew Vagin <avagin@openvz.org>,
        Borislav Petkov <bp@amd64.org>, David Howells <dhowells@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, arnaldo.melo@gmail.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 0/9] perf/core improvements and fixes
References: <1351261913-28250-1-git-send-email-acme@infradead.org> <20121026145451.GA14379@gmail.com>
In-Reply-To: <20121026145451.GA14379@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/12 8:54 AM, Ingo Molnar wrote:
>> perf/core improvements:
>>
>> . perf inject changes to allow showing where a task sleeps, from Andrew Vagin.
>>
>> . Makefile improvements from Namhyung Kim.
>
> These are really useful: there used to be a couple of seconds of
> wait time at the beginning of every perf build - these are now
> nicely explained with the various CHK entries.

PERF-VERSION-GEN and specifically the git commands are the cause of more 
delay than the config checks, especially when doing the build in a VM 
with the kernel source on an NFS mount.

David
