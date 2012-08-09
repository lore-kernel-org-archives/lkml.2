Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498Ab2HIFwq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 01:52:46 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:50528 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822Ab2HIFwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 01:52:45 -0400
X-AuditID: 9c930179-b7b65ae000006d01-10-5023502b7858
From: Namhyung Kim <namhyung@kernel.org>
To: Feng Tang <feng.tang@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>,
        Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH v5 5/5] perf script: Add event_analyzing_sample.py as a sample for general event handling
References: <1344419875-21665-1-git-send-email-feng.tang@intel.com>
	<1344419875-21665-6-git-send-email-feng.tang@intel.com>
	<87ipcsyhqd.fsf@sejong.aot.lge.com> <20120809123007.6f3f0a8f@feng-i7>
	<874nocy74u.fsf@sejong.aot.lge.com> <20120809132843.0e7bac75@feng-i7>
Date: Thu, 09 Aug 2012 14:46:51 +0900
In-Reply-To: <20120809132843.0e7bac75@feng-i7> (Feng Tang's message of "Thu, 9
	Aug 2012 13:28:43 +0800")
Message-ID: <87vcgswras.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Aug 2012 13:28:43 +0800, Feng Tang wrote:
> On Thu, 9 Aug 2012 14:19:29 +0900
>> Btw, by any chance do you plan to add support to callchains? I think
>> it's very nice to have.
>
> No, it's not on the plan list :). My next plan is to integrate the perf
> script to the perf report framework, so that users can directly call
> perf script inside perf report browser like running the annotation.
>

Sounds cool!

Thanks,
Namhyung
