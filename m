Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933207Ab2KEPZl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 10:25:41 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:58809 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933191Ab2KEPZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 10:25:33 -0500
Message-ID: <5097DA69.7070505@gmail.com>
Date: Mon, 05 Nov 2012 08:25:29 -0700
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
Subject: Re: [PATCH 2/3] perf tools: Introduce struct hist_browser_timer
References: <1351835406-15208-1-git-send-email-namhyung@kernel.org> <1351835406-15208-2-git-send-email-namhyung@kernel.org>
In-Reply-To: <1351835406-15208-2-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/1/12 11:50 PM, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
>
> Currently various hist browser functions receive 3 arguments for
> refreshing histogram but only used from a few places.  Also it's only
> for perf top command so that it can be NULL for other (and probably
> most) cases.  Pack them into a struct in order to reduce number of
> those unused arguments.
>
> This is a mechanical change and does not intend a functional change.
>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Irina Tirdea <irina.tirdea@gmail.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>   tools/perf/builtin-annotate.c     |  2 +-
>   tools/perf/builtin-report.c       |  4 ++--
>   tools/perf/builtin-top.c          |  9 +++++---
>   tools/perf/ui/browsers/annotate.c | 27 +++++++++++-------------
>   tools/perf/ui/browsers/hists.c    | 43 +++++++++++++++++----------------------
>   tools/perf/ui/gtk/browser.c       |  4 +---
>   tools/perf/util/annotate.h        |  8 ++++----
>   tools/perf/util/hist.h            | 28 ++++++++++++-------------
>   8 files changed, 58 insertions(+), 67 deletions(-)

Tested-by: David Ahern <dsahern@gmail.com>

