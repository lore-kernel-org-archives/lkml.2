Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211Ab2IUA2S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 20:28:18 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:52129 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755074Ab2IUA2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 20:28:17 -0400
X-AuditID: 9c930197-b7b6dae000000e70-bc-505bb49f71c0
From: Namhyung Kim <namhyung@kernel.org>
To: Irina Tirdea <irina.tirdea@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        David Ahern <dsahern@gmail.com>, Pekka Enberg <penberg@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Irina Tirdea <irina.tirdea@intel.com>
Subject: Re: [PATCH 4/4] perf tools: configure addr2line path at compile time
References: <1348179215-11160-1-git-send-email-irina.tirdea@gmail.com>
	<1348179215-11160-5-git-send-email-irina.tirdea@gmail.com>
Date: Fri, 21 Sep 2012 09:19:34 +0900
In-Reply-To: <1348179215-11160-5-git-send-email-irina.tirdea@gmail.com> (Irina
	Tirdea's message of "Fri, 21 Sep 2012 01:13:35 +0300")
Message-ID: <87boh0z0q1.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Sep 2012 01:13:35 +0300, Irina Tirdea wrote:
> From: Irina Tirdea <irina.tirdea@intel.com>
>
> The default name for addr2line is hardcoded to "addr2line".
> When cross-compiling the name of addr2line will be different
> (e.g. arm-eabi-addr2line in Android).
>
> Setting the default addr2line name in the Makefile with PERF_ADDR2LINE_PATH.

Please see my previous reply to PATCH 3/4.  It also applies here.

Thanks,
Namhyung
