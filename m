Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487Ab2JDBwi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 21:52:38 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:58245 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192Ab2JDBwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 21:52:36 -0400
X-AuditID: 9c930179-b7bf9ae000000e4c-e4-506cebe24e1d
From: Namhyung Kim <namhyung@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        David Ahern <dsahern@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] perf tools: Check existence of _get_comp_words_by_ref when bash completing
References: <1349191294-6926-1-git-send-email-namhyung@kernel.org>
	<1349191294-6926-2-git-send-email-namhyung@kernel.org>
	<20121002155358.GD10605@somewhere>
Date: Thu, 04 Oct 2012 10:43:03 +0900
In-Reply-To: <20121002155358.GD10605@somewhere> (Frederic Weisbecker's message
	of "Tue, 2 Oct 2012 17:54:10 +0200")
Message-ID: <87pq4zj9lk.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frederic,

On Tue, 2 Oct 2012 17:54:10 +0200, Frederic Weisbecker wrote:
> On Wed, Oct 03, 2012 at 12:21:32AM +0900, Namhyung Kim wrote:
>> The '_get_comp_words_by_ref' function is available from the bash
>> completion v1.2 so that earlier version emits following warning:
>> 
>>   $ perf re<TAB>_get_comp_words_by_ref: command not found
>> 
>> Use older '_get_cword' method when the above function doesn't exist.
>
> May be only use _get_cword then, if it works everywhere?

It'll work but it's deprecated.

Thanks,
Namhyung
