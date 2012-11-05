Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933215Ab2KEPZ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 10:25:58 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62973 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932974Ab2KEPZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 10:25:39 -0500
Message-ID: <5097DA6F.9000501@gmail.com>
Date: Mon, 05 Nov 2012 08:25:35 -0700
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
Subject: Re: [PATCH 3/3] perf report: Postpone objdump check until annotation
 requested
References: <1351835406-15208-1-git-send-email-namhyung@kernel.org> <1351835406-15208-3-git-send-email-namhyung@kernel.org>
In-Reply-To: <1351835406-15208-3-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/1/12 11:50 PM, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
>
> David reported that current perf report refused to run on a data file
> captured from a different machine because of objdump.  Since the
> objdump tools won't be used unless annotation was requested, checking
> its presence at init time doens't make sense.
>
> Reported-by: David Ahern <dsahern@gmail.com>
> Cc: Irina Tirdea <irina.tirdea@gmail.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>   tools/perf/builtin-report.c    |  9 ++-------
>   tools/perf/builtin-top.c       |  3 ++-
>   tools/perf/ui/browsers/hists.c | 22 ++++++++++++++++------
>   tools/perf/util/hist.h         |  7 +++++--
>   4 files changed, 25 insertions(+), 16 deletions(-)

Reviewed-by/Tested-by: David Ahern <dsahern@gmail.com>


