Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487Ab2IMCuF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 22:50:05 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:64876 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554Ab2IMCuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 22:50:03 -0400
X-AuditID: 9c930179-b7b30ae000004aa7-2c-505149d4d7f9
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Robert Richter <robert.richter@amd.com>, mingo@kernel.org, hpa@zytor.com,
        paulus@samba.org, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf hists: Introduce perf_hpp for hist period printing
References: <1346640790-17197-2-git-send-email-namhyung@kernel.org>
	<tip-ea251d51d2c7d7233790123227f787c477f567f5@git.kernel.org>
	<20120912172641.GB29278@erda.amd.com>
	<20120912184815.GC557@infradead.org>
Date: Thu, 13 Sep 2012 11:43:08 +0900
In-Reply-To: <20120912184815.GC557@infradead.org> (Arnaldo Carvalho de Melo's
	message of "Wed, 12 Sep 2012 15:48:15 -0300")
Message-ID: <87y5ke8wxv.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo and Robert,

On Wed, 12 Sep 2012 15:48:15 -0300, Arnaldo Carvalho de Melo wrote:
> Em Wed, Sep 12, 2012 at 07:26:41PM +0200, Robert Richter escreveu:
>> On 09.09.12 01:54:39, tip-bot for Namhyung Kim wrote:
>> 
>>  # perf record -e cycles -aq sleep 1 ; perf report -n --sort comm,dso | sed '/%/q;d' ; \
>>    perf record -e cycles -aq sleep 1 | perf report -n --sort comm,dso | sed '/%/q;d'
>>      99.86%        11804       swapper  [kernel.kallsyms]
>>      91.57%      swapper  [kernel.kallsyms]
>>            ^^^^^^
>>            number of samples missing
>> 
>> Moving and changing the code at the same time make the patch
>> unreviewable. So no clue that's the problem here.
>
> Yeah, that was unfortunate (movind and changing), we need to try hard
> not to do that...

Okay, will be careful next time.


>
> Anyway, Namhyung, can you take a look at this?

Sure, I'll take a look.

Thanks,
Namhyung
