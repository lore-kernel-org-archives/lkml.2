Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762653Ab2KBCXi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 22:23:38 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:44568 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762589Ab2KBCXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 22:23:37 -0400
X-AuditID: 9c930179-b7c8bae000003559-66-50932ea7a853
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 00/25] perf test: Add perf_event_attr tests
References: <1351634526-1516-1-git-send-email-jolsa@redhat.com>
	<20121101203800.GA3911@ghostprotocols.net>
	<20121101232055.GA1690@krava.redhat.com>
	<87objg4wzl.fsf@sejong.aot.lge.com>
Date: Fri, 02 Nov 2012 11:23:35 +0900
In-Reply-To: <87objg4wzl.fsf@sejong.aot.lge.com> (Namhyung Kim's message of
	"Fri, 02 Nov 2012 10:25:18 +0900")
Message-ID: <878vak4uag.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 02 Nov 2012 10:25:18 +0900, Namhyung Kim wrote:
> namhyung@sejong:perf$ cat tests/attr/test-stat-group1 
> [config]
> command = stat
> args    = -e '{cycles,instructions}' kill >/dev/null 2>&1
> ret     = 1
>
> [event-1:base-stat]
> fd=1
> group_fd=-1
>
> [event-2:base-stat]
> fd=2
> group_fd=1
> config=1
> # TODO both disabled and enable_on_exec are disabled for --group option,
> #      enabled otherwise, check why..
> disabled=1
> enable_on_exec=1

Oh I realize that I don't have the base-stat file.

  namhyung@sejong:perf$ cat tests/attr/base-stat
  cat: tests/attr/base-stat: No such file or directory

Thanks,
Namhyung
