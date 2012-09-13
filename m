Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751474Ab2IME2v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 00:28:51 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:45961 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783Ab2IME2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 00:28:46 -0400
X-AuditID: 9c930197-b7b6dae000000e70-e5-505160fc4214
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Robert Richter <robert.richter@amd.com>, mingo@kernel.org, hpa@zytor.com,
        paulus@samba.org, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [PATCH] perf record: Add missing perf_hpp__init for pipe-mode
References: <1346640790-17197-2-git-send-email-namhyung@kernel.org>
	<tip-ea251d51d2c7d7233790123227f787c477f567f5@git.kernel.org>
	<20120912172641.GB29278@erda.amd.com>
	<20120912184815.GC557@infradead.org>
	<87y5ke8wxv.fsf@sejong.aot.lge.com>
	<87txv28spl.fsf_-_@sejong.aot.lge.com>
Date: Thu, 13 Sep 2012 13:21:57 +0900
In-Reply-To: <87txv28spl.fsf_-_@sejong.aot.lge.com> (Namhyung Kim's message of
	"Thu, 13 Sep 2012 13:14:30 +0900")
Message-ID: <87pq5q8sd6.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oops, please do s/record/report/ on the subject line, sorry! ;-)

Also I don't see the issue on the other users of the setup_browser() -
i.e. perf annotate and perf top - since they call it unconditionally.

Thanks,
Namhyung
