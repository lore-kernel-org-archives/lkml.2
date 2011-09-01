Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757499Ab1IAMpq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 08:45:46 -0400
Received: from smtp-out.google.com ([216.239.44.51]:39467 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757370Ab1IAMpp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 08:45:45 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=qLHP1WmYH5jkVg8VevLw+Vln5m+SkkthWuRv0ZbYhQbiVmkwe3Pir/+GnT3Mkqx/Q
	8R4jCdKWWR67HZe8UgXzA==
MIME-Version: 1.0
In-Reply-To: <1314880722.2867.4.camel@hp6530s>
References: <20110831124125.GA10443@quad>
	<1314880722.2867.4.camel@hp6530s>
Date: Thu, 1 Sep 2011 14:45:39 +0200
Message-ID: <CABPqkBTzCfjRO=5MAA1Uh_k2wxa38oZY4RMybrL4-04R1Hb7zQ@mail.gmail.com>
Subject: Re: [PATCH] perf_event: fix Ming's Intel NHM/WSM/SNB uncore PMU patch
From: Stephane Eranian <eranian@google.com>
To: Lin Ming <ming.m.lin@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "acme@ghostprotocols.net" <acme@ghostprotocols.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 1, 2011 at 2:38 PM, Lin Ming <ming.m.lin@intel.com> wrote:
> On Wed, 2011-08-31 at 20:41 +0800, Stephane Eranian wrote:
>> The following patch sits on top of Lin Ming's patch
>> which adds support for Intel uncore PMU on NHM/WSM/SNB.
>> The patch series was posted on LKML in July 2011.
>>
>> The patches fixes:
>>   - nhm_uncore_pmu_enable_all() to also enabled the fixed uncore counters
>>   - uncore_pmu_add() to schedule for the actual max number of generic counters
>>   - fixed the NHM/WSM vs. SNB MSRs for the fixed counter, they are swapped
>>
>> The patch adds the following improvement:
>>   - add an event group validation function, to check if a group can ever be
>>     schedule. This way, the behavior is consistent with core PMU event groups.
>>
>> Signed-off-by: Stephane Eranian <eranian@google.com>
>
> Can I merge this patch into my series with these change logs and your
> signed-off-by?
>
Yes.

> Thanks,
> Lin Ming
>
>
