Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758334Ab2ETCzR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 22:55:17 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56499 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758198Ab2ETCzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 22:55:14 -0400
Message-ID: <4FB85D0C.7070108@gmail.com>
Date: Sat, 19 May 2012 20:55:08 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Namhyung Kim <namhyung@gmail.com>, Namhyung Kim <namhyung.kim@lge.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@google.com>, arnaldo.melo@gmail.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 0/6] perf/core fixes
References: <1337480196-761-1-git-send-email-acme@infradead.org>
In-Reply-To: <1337480196-761-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/19/12 8:16 PM, Arnaldo Carvalho de Melo wrote:

> Arnaldo Carvalho de Melo (1):
>        Merge remote-tracking branch 'tip/perf/urgent' into perf/core
>
> David Ahern (1):
>        perf evsel: Create events initially disabled -- again
>
> Jiri Olsa (2):
>        perf hists: Fix callchain ip printf format
>        perf tools: Split term type into value type and term type
>
> Namhyung Kim (3):
>        perf target: Rename functions to avoid double negation
>        Revert 'perf evlist: Fix creation of cpu map'
>        perf target: Add uses_mmap field

What about Stephane's pipe mode patch set? The first 3 and the last one 
of the 5 are good fixes to pick up.

David
