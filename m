Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759739Ab2EVD3Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 23:29:16 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44773 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758226Ab2EVD3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 23:29:13 -0400
Message-ID: <4FBB0804.5080605@gmail.com>
Date: Mon, 21 May 2012 21:29:08 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/7] perf, tool: Add union u64_swap type for swapping
 u64 data
References: <1337151548-2396-1-git-send-email-jolsa@redhat.com> <1337151548-2396-4-git-send-email-jolsa@redhat.com>
In-Reply-To: <1337151548-2396-4-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/16/12 12:59 AM, Jiri Olsa wrote:
> The following union:
>    union {
>          u64 val64;
>          u32 val32[2];
>    } u;
>
> is used on more than single places in perf code and will be used
> more in upcomming patches.
>
> Adding union u64_swap to have it defined globaly so we dont need
> to redefine it all the time.
>
> Signed-off-by: Jiri Olsa<jolsa@redhat.com>
> ---
>   tools/perf/util/evsel.c |   10 ++--------
>   tools/perf/util/types.h |    5 +++++
>   2 files changed, 7 insertions(+), 8 deletions(-)
>

Reviewed-by and Tested-by: David Ahern <dsahern@gmail.com>
