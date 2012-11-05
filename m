Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933190Ab2KEPZd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 10:25:33 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62973 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932934Ab2KEPZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 10:25:26 -0500
Message-ID: <5097DA62.90609@gmail.com>
Date: Mon, 05 Nov 2012 08:25:22 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Irina Tirdea <irina.tirdea@gmail.com>
Subject: Re: [PATCH RESEND 1/3] perf tools: Use normalized arch name for searching
 objdump path
References: <1351835406-15208-1-git-send-email-namhyung@kernel.org>
In-Reply-To: <1351835406-15208-1-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/1/12 11:50 PM, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
>
> David reported that perf report for i686 target data on x86_64 host
> failed to work because it tried to find out cross-compiled objdump.
>
> However objdump for x86_64 is compatible to i686 so that it doesn't
> need to do it at all.  To prevent similar artifacts, normalize arch
> name when comparing host and file architectures.
>
> Reported-by: David Ahern <dsahern@gmail.com>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Irina Tirdea <irina.tirdea@gmail.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>   tools/perf/arch/common.c | 40 +++++++++++++++++++++++++++++++++-------
>   1 file changed, 33 insertions(+), 7 deletions(-)


Reviewed-by/Tested-by: David Ahern <dsahern@gmail.com>

