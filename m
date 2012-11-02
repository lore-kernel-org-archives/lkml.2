Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762689Ab2KBCsU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 22:48:20 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:55912 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758251Ab2KBCsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 22:48:17 -0400
X-AuditID: 9c930179-b7c8bae000003559-a5-5093346fc9d1
From: Namhyung Kim <namhyung@kernel.org>
To: Feng Tang <feng.tang@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] perf report: Enable the runtime switching of perf data file
References: <1351699257-5102-1-git-send-email-feng.tang@intel.com>
	<1351699257-5102-3-git-send-email-feng.tang@intel.com>
Date: Fri, 02 Nov 2012 11:48:15 +0900
In-Reply-To: <1351699257-5102-3-git-send-email-feng.tang@intel.com> (Feng
	Tang's message of "Thu, 1 Nov 2012 00:00:57 +0800")
Message-ID: <871ugc4t5c.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Feng,

On Thu,  1 Nov 2012 00:00:57 +0800, Feng Tang wrote:
> This is for tui browser only. This patch will check the returned
> key of tui hists browser, if it's K_SWITH_INPUT_DATA, then recreate
> a session for the new selected data file.

You may want to add my previous patch [1] to your patch set as it can
call perf_session__delete() multiple times.

Thanks,
Namhyung

[1] https://lkml.org/lkml/2012/9/24/693
