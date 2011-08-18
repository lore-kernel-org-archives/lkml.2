Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818Ab1HRCPu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 22:15:50 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:65497 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754424Ab1HRCPt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 22:15:49 -0400
Message-ID: <4E4C75F0.10701@cn.fujitsu.com>
Date: Thu, 18 Aug 2011 10:16:16 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Geunsik Lim <leemgs1@gmail.com>
CC: Jiri Kosina <trivial@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Joe Perches <joe@perches.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] file info modification to maintain perf
References: <1313633289-11410-1-git-send-email-leemgs1@gmail.com>
In-Reply-To: <1313633289-11410-1-git-send-email-leemgs1@gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-18 10:14:35,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-18 10:14:36,
	Serialize complete at 2011-08-18 10:14:36
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geunsik Lim wrote:
> From: Geunsik Lim <geunsik.lim@samsung.com>
> 
> Actually, perf related c sources depends on architecture core.
> So,'./kernel/perf_event.c'file still not exist from the latest
> linux version.
> 

kernel/perf_event.c has been splitted and moved to kernel/events/*

> Signed-off-by: Geunsik Lim <geunsik.lim@samsung.com>
> ---
>  MAINTAINERS |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 1d445f5..7ae72d49 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4971,7 +4971,6 @@ M:	Paul Mackerras <paulus@samba.org>
>  M:	Ingo Molnar <mingo@elte.hu>
>  M:	Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
>  S:	Supported
> -F:	kernel/perf_event*.c
>  F:	include/linux/perf_event.h
>  F:	arch/*/kernel/perf_event*.c
>  F:	arch/*/kernel/*/perf_event*.c
