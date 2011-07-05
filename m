Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857Ab1GEQBj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 12:01:39 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54759 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754587Ab1GEQBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 12:01:37 -0400
Message-ID: <cf54fbb6e05ab86a5c6029eda70012e4.squirrel@www.firstfloor.org>
In-Reply-To: <1309864954.3282.61.camel@twins>
References: <1309421396-17438-1-git-send-email-ming.m.lin@intel.com>
    <1309421396-17438-2-git-send-email-ming.m.lin@intel.com>
    <20110630165849.GE23059@one.firstfloor.org>
    <1309761541.18875.40.camel@minggr.sh.intel.com>
    <20110704215706.GH15637@one.firstfloor.org>
    <1309864954.3282.61.camel@twins>
Date: Tue, 5 Jul 2011 18:01:36 +0200
Subject: Re: [PATCH 1/4] perf, x86: Add Intel Nehalem/Westmere uncore pmu
From: "Andi Kleen" <andi@firstfloor.org>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Cc: "Andi Kleen" <andi@firstfloor.org>, "Lin Ming" <ming.m.lin@intel.com>,
        "Ingo Molnar" <mingo@elte.hu>, "Stephane Eranian" <eranian@google.com>,
        "Arnaldo Carvalho de Melo" <acme@ghostprotocols.net>,
        "linux-kernel" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.21
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>
>>   But it's not strictly required I would say,
>> 44(?) bits are probably enough for near all use cases.
>
> 44bits is in the hours range for pure cycle counts, which is so-so. I
> bet you're going to be very annoyed when you find your counters are
> wrecked after your 5 hour test run finishes.

For these kinds of long running measurements you usually care about
ratios, not absolutes. Some infrequent wrapping should not substantially
change.
those.

-Andi

