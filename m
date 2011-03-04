Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760184Ab1CDVTz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 16:19:55 -0500
Received: from smtp-out.google.com ([216.239.44.51]:32381 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778Ab1CDVTy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 16:19:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DHHAEHXrzOLtwOPy/5r1ZYg2HNiOXz2ciK1qgYyLMkU3rpQhDs87W03+OgqsroYSvd
         7a0Xc+oyWqTtvC1H/RTg==
MIME-Version: 1.0
In-Reply-To: <20110302081430.GE15665@elte.hu>
References: <4d6d636b.98a1df0a.15d8.57d1@mx.google.com>
	<1299027401.4937.106.camel@minggr.sh.intel.com>
	<AANLkTimkAuDQOW8J=vqcz-7r9gaN_=qq1=guBh6n6A7u@mail.gmail.com>
	<20110302081430.GE15665@elte.hu>
Date: Fri, 4 Mar 2011 22:19:48 +0100
Message-ID: <AANLkTi=ZSKepq5n_CpA7jNaUEjBWzeECuHJxi9VXr821@mail.gmail.com>
Subject: Re: [PATCH] perf_events: update PEBS event constraints (v2)
From: Stephane Eranian <eranian@google.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Lin Ming <ming.m.lin@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "paulus@samba.org" <paulus@samba.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "perfmon2-devel@lists.sf.net" <perfmon2-devel@lists.sf.net>,
        "eranian@gmail.com" <eranian@gmail.com>,
        "robert.richter@amd.com" <robert.richter@amd.com>,
        "acme@redhat.com" <acme@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the delay. I realize I did not answer this message earlier.


On Wed, Mar 2, 2011 at 9:14 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Stephane Eranian <eranian@google.com> wrote:
>
>> On Wed, Mar 2, 2011 at 1:56 AM, Lin Ming <ming.m.lin@intel.com> wrote:
>> > On Wed, 2011-03-02 at 04:20 +0800, Stephane Eranian wrote:
>> >> This patch updates PEBS event constraints for Intel Atom, Nehalem, Westmere.
>> >>
>> >> This patch also reorganizes the PEBS format/constraint detection code. It is
>> >> now based on processor model and not PEBS format. Two processors may use the
>> >> same PEBS format without have the same list of PEBS events.
>> >>
>> >> In this second version, we simplified the initialization of the PEBS constraints
>> >> by leveraging the existing switch() statement in perf_event_intel.c. We also
>> >> renamed the constraint tables to be more consistent with regular constraints.
>> >
>> > Hi, Stephane
>> >
>> > Nice updates.
>> > Wondering where did you get these PEBS event constraints? I didn't find
>> > these in the latest manual.
>> >
>> Yeah, the manual is lacking some information. The other source of information
>> is the PTU event files (whatif.intel.com).
>
> Plus i suspect you have performed testing on affected CPUs as well?
>
Yes, I did.

> If yes then i think we want to push these fixes via perf/urgent - they seem to
> nicely round up the constraints.
>
> Thanks,
>
>        Ingo
>
