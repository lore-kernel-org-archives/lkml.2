Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757416Ab2EHDh3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 23:37:29 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53109 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941Ab2EHDh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 23:37:27 -0400
Message-ID: <4FA894F3.10500@gmail.com>
Date: Mon, 07 May 2012 21:37:23 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, Caspar Zhang <czhang@redhat.com>
Subject: Re: [PATCHv3 0/5] perf, tool: Fix endian issues
References: <1336390149-2970-1-git-send-email-jolsa@redhat.com> <4FA8811C.6050300@gmail.com>
In-Reply-To: <4FA8811C.6050300@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/7/12 8:12 PM, David Ahern wrote:
>
> LINK /tmp/pbuild/perf
> /tmp/pbuild/libperf.a(pmu.o): In function `pmu_format_parse':
> /mnt/src/tools/perf/util/pmu.c:47: undefined reference to `perf_pmu_in'
> /mnt/src/tools/perf/util/pmu.c:47: undefined reference to `perf_pmu_in'
> /tmp/pbuild/libperf.a(pmu-bison.o): In function `perf_pmu_parse':
> /tmp/pbuild/util/pmu-bison.c:1287: undefined reference to `perf_pmu_lex'
> collect2: ld returned 1 exit status
> make: *** [/tmp/pbuild/perf] Error 1

nevermind. This one is a weird side effect of not having flex and bison 
installed the first time I tried compiling it. After nuking the build 
directory, installing flex and bison, perf compiled fine.

David
