Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673Ab2ISG4z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 02:56:55 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:59721 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166Ab2ISG4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 02:56:54 -0400
X-AuditID: 9c93016f-b7c19ae000000e6d-d4-50596cb23a73
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, arnaldo.melo@gmail.com
Subject: Re: [RFC 0/4] Some libtraceevent cleanups/simplifications
References: <1347915049-19093-1-git-send-email-acme@infradead.org>
Date: Wed, 19 Sep 2012 15:48:16 +0900
In-Reply-To: <1347915049-19093-1-git-send-email-acme@infradead.org> (Arnaldo
	Carvalho de Melo's message of "Mon, 17 Sep 2012 17:50:45 -0300")
Message-ID: <877grq33v3.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Sep 2012 17:50:45 -0300, Arnaldo Carvalho de Melo wrote:
> Hi Steven,
>
> 	Please take a look, while looking at how to do some stuff in 'perf
> test' just for parsing the /format file I ended up with this series, lemme know
> if I can add your Acked-by and push via my perf/core branch.

With my add-on patch, the series looks good to me.  You can add my

  Reviewed-by: Namhyung Kim <namhyung@kernel.org>

if you want. :)

Thanks,
Namhyung
