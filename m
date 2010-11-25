Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517Ab0KYVKJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 16:10:09 -0500
Received: from smtp-out.google.com ([216.239.44.51]:60431 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090Ab0KYVKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 16:10:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=mhjwrPsrmVHfqdMxILg57ImU/sjtnsMrEQCkGAsg1QHBJb2TyQD1zrg/vNp8Iv2GbM
         nEclXOGX4FbwqE57hR/A==
MIME-Version: 1.0
In-Reply-To: <20101125182052.GA7413@basil.fritz.box>
References: <1290340877.2245.124.camel@localhost>
	<8e9ff9280b0c4a059bc82b5c4a629897.squirrel@www.firstfloor.org>
	<1290348259.2245.172.camel@localhost>
	<1290361473.2153.39.camel@laptop>
	<AANLkTik2_VLiKfZNC3BJeFnqS8kp7bMOg6qhJ1yPGmej@mail.gmail.com>
	<1290644675.2405.90.camel@minggr.sh.intel.com>
	<1290665350.2072.521.camel@laptop>
	<20101125182052.GA7413@basil.fritz.box>
Date: Thu, 25 Nov 2010 22:10:02 +0100
Message-ID: <AANLkTimb_DR+c7BJMdN4QgdT_7WwRMixQGXaOFEwqDDt@mail.gmail.com>
Subject: Re: [RFC PATCH 2/3 v2] perf: Implement Nehalem uncore pmu
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Lin Ming <ming.m.lin@intel.com>,
        Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arjan van de Ven <arjan@infradead.org>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 25, 2010 at 7:20 PM, Andi Kleen <andi@firstfloor.org> wrote:
>> Yep, I see no reason to dis-allow sampling. Sure its hard to make sense
>> of it, but since there are people who offline all but one cpu of a
>> package,
>
> Assuming they don't have any active PCI devices either.
>
Good point.

>> I bet there are people who will run just one task on a package
>> as well.
>
> In that case the sampling has a 1/NUM-CPU-THREADS-IN-PACKAGE chance
> to report the right task (or actually somewhat less because the measurement
> skew for uncore is much higher than for normal events)
>
> Really for per core measurements using the OFFCORE events is much better.
>
yes, OFFCORE_RESPONSE is much more useful.
