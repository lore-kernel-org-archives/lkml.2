Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232Ab2EXJDo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 05:03:44 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:50026 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924Ab2EXJDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 05:03:43 -0400
X-AuditID: 9c93016f-b7c3cae000001954-6b-4fbdf96dab4c
From: Namhyung Kim <namhyung.kim@lge.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf, x86: Make cycles:p working on SNB
References: <1337828525-1789-1-git-send-email-namhyung.kim@lge.com>
	<1337844471.9783.48.camel@laptop>
	<CABPqkBRcz1a738M7g484B0p-dJrKqP6GSLE7gpPN0H1w-72oWw@mail.gmail.com>
	<1337845936.9783.57.camel@laptop> <1337846272.9783.59.camel@laptop>
	<CABPqkBQDpoQChAB_GmhuGStPEdjGUVkAg5cE=zH143L9u8pN-A@mail.gmail.com>
	<1337846873.9783.66.camel@laptop>
Date: Thu, 24 May 2012 18:01:23 +0900
In-Reply-To: <1337846873.9783.66.camel@laptop> (Peter Zijlstra's message of
	"Thu, 24 May 2012 10:07:53 +0200")
Message-ID: <87obpeq7fg.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 May 2012 10:07:53 +0200, Peter Zijlstra wrote:
> On Thu, 2012-05-24 at 10:00 +0200, Stephane Eranian wrote:
>> The PREC_DIST is by design, it is not a work-around of any sort.
>> It is an attempt at getting a better distribution of samples when sampling
>> with inst_retired.
>
> Oh completely agreed, note that my patch used UOPS_RETIRED.ALL. Only
> Namhyung used PREC_DIST, mostly I suspect because he's not stared at all
> these manuals for long yet ;-)

True. :)

Thanks,
Namhyung
