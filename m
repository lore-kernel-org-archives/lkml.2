Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932827Ab1JDQlI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 12:41:08 -0400
Received: from mga14.intel.com ([143.182.124.37]:60058 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932522Ab1JDQlH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 12:41:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,485,1312182000"; 
   d="scan'208";a="23178564"
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>, Don Zickus <dzickus@redhat.com>,
        acme <acme@ghostprotocols.net>,
        =?utf-8?B?RnLDqWTDqXJpYw==?= Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [V3][PATCH 0/7] perf, x86: Implement AMD IBS
References: <1316597423-25723-1-git-send-email-robert.richter@amd.com>
	<1316778523.9084.17.camel@twins> <20110923122014.GP6063@erda.amd.com>
	<1317716839.25926.12.camel@twins> <20111004085409.GA18566@elte.hu>
Date: Tue, 04 Oct 2011 09:41:03 -0700
In-Reply-To: <20111004085409.GA18566@elte.hu> (Ingo Molnar's message of "Tue,
	4 Oct 2011 10:54:09 +0200")
Message-ID: <m2botwlnfk.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:
>
>  - Testable IBS user-space code a bit more prominently integrated
>    than having to go down into a cellar with no working lights and 
>    finding the code on display in tools/perf/Documentation/examples/ 
>    on the bottom of a locked filing cabinet stuck in a disused
>    lavatory with a sign on the door saying 'Beware of the Leopard.'

I looked at this for PEBS, and the best solution currently seems
to be a python script that works with perf script and does some post
processing to present the data as summary or individual samples.
I assume that could work for IBS too.

Comments?

-Andi
