Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882Ab2F1QQE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 12:16:04 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48304 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755825Ab2F1QQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 12:16:00 -0400
MIME-Version: 1.0
In-Reply-To: <1340899974.28750.66.camel@twins>
References: <1340899250-26803-1-git-send-email-feng.tang@intel.com>
	<1340899974.28750.66.camel@twins>
Date: Thu, 28 Jun 2012 18:15:58 +0200
Message-ID: <CABPqkBSKQ1r_XvKZX5d59Jx3CJ8WoXsO1JJ4KfSiMng4EbH3tA@mail.gmail.com>
Subject: Re: [PATCH] perf, x86: Enabled PEBS event to be exported in a raw format
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Feng Tang <feng.tang@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I will cover some useful use cases with my PEBS-LL patchset + perf support.

On Thu, Jun 28, 2012 at 6:12 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2012-06-29 at 00:00 +0800, Feng Tang wrote:
>> From: Andi Kleen <ak@linux.intel.com>
>>
>> Add support for reporting PEBS records in a raw format that can
>> be then parsed by perf script.
>>
>> This is roughly similar to the existing AMD IBS support.
>>
>> This is mainly for advanced users and to experiment with
>> new usages. Widespread PEBS usages are expected to get higher
>> level interfaces over time, like the existing "precise ip" support.
>>
>> [Small fix of adding "data.raw = &raw;", thanks to Andi, with this
>> patch I can test my perf script with pebs samples. - Feng]
>>
>> Signed-off-by: Andi Kleen <ak@linux.intel.com>
>> Signed-off-by: Feng Tang <feng.tang@intel.com>
>
> Not without a useful userspace part. Preferably not a script.
