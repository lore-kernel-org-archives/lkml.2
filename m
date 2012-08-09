Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800Ab2HIGVj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 02:21:39 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:44894 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754659Ab2HIGVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 02:21:38 -0400
X-AuditID: 9c93016f-b7b08ae00000790d-54-502356f08803
From: Namhyung Kim <namhyung@kernel.org>
To: Feng Tang <feng.tang@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, David Ahern <dsahern@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH v2] perf script python: Correct handler check and spelling errors
References: <1344446028-21381-1-git-send-email-acme@infradead.org>
	<1344446028-21381-12-git-send-email-acme@infradead.org>
	<878vdoydj2.fsf@sejong.aot.lge.com> <20120809132401.64a18d27@feng-i7>
	<87zk64wru6.fsf@sejong.aot.lge.com> <20120809134613.067104c4@feng-i7>
Date: Thu, 09 Aug 2012 15:15:44 +0900
In-Reply-To: <20120809134613.067104c4@feng-i7> (Feng Tang's message of "Thu, 9
	Aug 2012 13:46:13 +0800")
Message-ID: <87r4rgwpyn.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Aug 2012 13:46:13 +0800, Feng Tang wrote:
> From efbf00591514aa1d6134a3b940dc627d1a7cc8f8 Mon Sep 17 00:00:00 2001
> From: Feng Tang <feng.tang@intel.com>
> Date: Thu, 9 Aug 2012 12:50:56 +0800
> Subject: [PATCH] perf script python: Correct handler check and spelling errors
>
> Correct the checking for handler returned by PyDict_GetItemString(), also
> fix some spelling error and remove some data code in event_analyzing_sample.py,
> as suggested by Namhyung Kim.
>
> v2: restore back the wrongly removed trace_unhandled() func
>
> Signed-off-by: Feng Tang <feng.tang@intel.com>

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks!
