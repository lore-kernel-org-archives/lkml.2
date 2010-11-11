Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757213Ab0KKV3e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 16:29:34 -0500
Received: from smtp-out.google.com ([216.239.44.51]:14154 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757155Ab0KKV3c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 16:29:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=aKX1MprymoNXs9ngsuCDTD5ogks5OrE4Aag0G/u0+/hD6X6yd+rn3igGMTiwfjHrfX
         YQC0pIByEcSfkqA9U40A==
MIME-Version: 1.0
In-Reply-To: <4CDC3974.3000506@linux.intel.com>
References: <1289492117-18066-1-git-send-email-andi@firstfloor.org>
	<8762w3pxuy.fsf@basil.nowhere.org>
	<AANLkTi=-OjDaz9iDm1aNYzeFsHmewTNnGBS8pRx1vfJT@mail.gmail.com>
	<4CDC3974.3000506@linux.intel.com>
Date: Thu, 11 Nov 2010 22:29:17 +0100
Message-ID: <AANLkTi=KVcsN_x+F24dbnU32yrEef_Uq4nq=OwyTbpBk@mail.gmail.com>
Subject: Re: [PATCH/FIX] perf-events: Put the per cpu state for intel_pmu too
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, a.p.zijlstra@chello.nl, mingo@elte.hu,
        acme@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 11, 2010 at 7:44 PM, Andi Kleen <ak@linux.intel.com> wrote:
> On 11/11/2010 6:54 PM, Stephane Eranian wrote:
>>
>> On Thu, Nov 11, 2010 at 6:35 PM, Andi Kleen<andi@firstfloor.org>  wrote:
>>>
>>> Small bug fix for the earlier offcore_response patch:
>>> need to put the events for intel_pmu too, not only core_pmu.
>>>
>> You don't need it for core pmu, this is for Core Duo/Solo
>> if I recall correctly.
>
> It shouldn't matter because Core Duo doesn't have any per CPU resources, but
> it seems more symetric to call it in any case.
>
There is no HT on these processors. I don't know of any valuable HW
features that is
not support for these.
