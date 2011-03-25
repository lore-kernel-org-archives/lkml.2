Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479Ab1CYOFy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 10:05:54 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35759 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160Ab1CYOFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 10:05:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=qJSfO9X4yCPcdMLRbsC99tFh414D/PxHPll3MpFQ5dWbAqsR5avtBdLPQBXJxD2bqM
         s1a6pOtz+QYQEetai/uu+duboG0HylZr69+OO/Glj36bQQi5qTTXE/a3a9QciUu05UYP
         Z8NNL7IHn1A3DIGY4PP3/tRjcoiMyseKhiTiM=
MIME-Version: 1.0
In-Reply-To: <1300879469.23962.40.camel@e102109-lin.cambridge.arm.com>
References: <1300299394-20844-1-git-send-email-dbaluta@ixiacom.com>
	<1300879469.23962.40.camel@e102109-lin.cambridge.arm.com>
Date: Fri, 25 Mar 2011 16:05:51 +0200
X-Google-Sender-Auth: DReS9XJymsWfdMseAuVWKubzY60
Message-ID: <AANLkTik-LbTo6TcdBuJxg7sGmPX-0tpiZHwgHRWBQc_f@mail.gmail.com>
Subject: Re: [PATCH] kmemleak: build kmemleak-test.c as a module-only
From: Daniel Baluta <dbaluta@ixiacom.com>
To: Catalin Marinas <catalin.marinas@arm.com>, paulmck@linux.vnet.ibm.com,
        akpm@linux-foundation.org, mingo@elte.hu, fweisbec@gmail.com,
        rdunlap@xenotime.net
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 1:24 PM, Catalin Marinas
<catalin.marinas@arm.com> wrote:
> On Wed, 2011-03-16 at 18:16 +0000, Daniel Baluta wrote:
>> mm/kmemleak-test.c is used to provide an example of how kmemleak
>> tool works.
>>
>> Memory is leaked at module unload-time, so building the test
>> in kernel (Y) makes the leaks impossible and the test useless.
>>
>> Qualify DEBUG_KMEMLEAK_TEST config symbol with "depends on m",
>> to restrict module-only building.
>>
>> Signed-off-by: Daniel Baluta <dbaluta@ixiacom.com>
>
> Sorry for the delay.
>
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>

Who should pick this up?

$ scripts/get_maintainer.pl lib/this.patch says:
Andrew Morton <akpm@linux-foundation.org> (commit_signer:8/56=14%)
"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> (commit_signer:7/56=12%)
Ingo Molnar <mingo@elte.hu> (commit_signer:5/56=9%)
Frederic Weisbecker <fweisbec@gmail.com> (commit_signer:5/56=9%)
Randy Dunlap <rdunlap@xenotime.net> (commit_signer:3/56=5%)

Am I missing something?

thanks,
Daniel.
