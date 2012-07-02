Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641Ab2GBBes (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 21:34:48 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:61004 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754494Ab2GBBer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 21:34:47 -0400
X-AuditID: 9c930197-b7b49ae0000027b8-c8-4ff0fab4ae9d
From: Namhyung Kim <namhyung@kernel.org>
To: Hitoshi Mitake <h.mitake@gmail.com>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Subject: Re: [PATCH] perf bench: fix confused variable namings and descriptions in mem subsystem
References: <1341155183-15403-1-git-send-email-h.mitake@gmail.com>
Date: Mon, 02 Jul 2012 10:30:31 +0900
In-Reply-To: <1341155183-15403-1-git-send-email-h.mitake@gmail.com> (Hitoshi
	Mitake's message of "Mon, 2 Jul 2012 00:06:23 +0900")
Message-ID: <87k3ynlzk8.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon,  2 Jul 2012 00:06:23 +0900, Hitoshi Mitake wrote:
> As Namhyung Kim pointed, there are confused namings and descriptions
> of words "cycle" and "clock" in mem-memset.c and mem-memcpy.c.
>
> With the option "-c" (or "--clock", now renamed as "--cycle"), mem
> subsystem measures cost of memset() and memcpy() with cpu-cycles
> event.
>
> But current mem subsystem source code contains lots of confused
> variable namings and descriptions with "clock" (e.g. the variable
> use_clock). This is a very bad style because there is another software
> event named "cpu-clock". This patch replaces wrong usage of "clock" to
> "cycle".
>

Could you fix the Documentation/perf-bench.txt also?

Thanks,
Namhyung

