Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756943Ab1CaHor (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 03:44:47 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:59531 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793Ab1CaHoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 03:44:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=wN0JS6alrHO3t/DVxmLCKMr7DMwY+vzZNdCtQPupNHj3KfPQOT4i3Z5q/n8YP9h5Ha
         52cbh3MKBF5J17ThMTrJxxmKNGyzeR30wuPSiuZF5+1aKdter8fb2nTvstHvAIaUJQLU
         RAEXRzu7Z+zowUSjK893pexYfgfhcJwNXFMUc=
MIME-Version: 1.0
In-Reply-To: <20110330082419.b782fa94.rdunlap@xenotime.net>
References: <1300299394-20844-1-git-send-email-dbaluta@ixiacom.com>
	<1300879469.23962.40.camel@e102109-lin.cambridge.arm.com>
	<AANLkTik-LbTo6TcdBuJxg7sGmPX-0tpiZHwgHRWBQc_f@mail.gmail.com>
	<AANLkTim3-6vrS8uEEm+jsuSJ64z_Edq40+MqF-m2ve5=@mail.gmail.com>
	<20110330082419.b782fa94.rdunlap@xenotime.net>
Date: Thu, 31 Mar 2011 10:44:45 +0300
Message-ID: <AANLkTinqt8jab0Q7W2gPjYD31yiObP_q8=LR5j28wRUy@mail.gmail.com>
Subject: Re: [PATCH] kmemleak: build kmemleak-test.c as a module-only
From: Daniel Baluta <daniel.baluta@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Catalin Marinas <catalin.marinas@arm.com>, paulmck@linux.vnet.ibm.com,
        akpm@linux-foundation.org, mingo@elte.hu, fweisbec@gmail.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        penberg@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30, 2011 at 6:24 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On Wed, 30 Mar 2011 18:02:02 +0300 Daniel Baluta wrote:
>
>> On Fri, Mar 25, 2011 at 4:05 PM, Daniel Baluta <dbaluta@ixiacom.com> wrote:
>> > On Wed, Mar 23, 2011 at 1:24 PM, Catalin Marinas
>> > <catalin.marinas@arm.com> wrote:
>> >> On Wed, 2011-03-16 at 18:16 +0000, Daniel Baluta wrote:
>> >>> mm/kmemleak-test.c is used to provide an example of how kmemleak
>> >>> tool works.
>> >>>
>> >>> Memory is leaked at module unload-time, so building the test
>> >>> in kernel (Y) makes the leaks impossible and the test useless.
>> >>>
>> >>> Qualify DEBUG_KMEMLEAK_TEST config symbol with "depends on m",
>> >>> to restrict module-only building.
>> >>>
>> >>> Signed-off-by: Daniel Baluta <dbaluta@ixiacom.com>
>> >>
>> >> Sorry for the delay.
>> >>
>> >> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
>> >
>> > Who should pick this up?
>> >
>> > $ scripts/get_maintainer.pl lib/this.patch says:
>> > Andrew Morton <akpm@linux-foundation.org> (commit_signer:8/56=14%)
>> > "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> (commit_signer:7/56=12%)
>> > Ingo Molnar <mingo@elte.hu> (commit_signer:5/56=9%)
>> > Frederic Weisbecker <fweisbec@gmail.com> (commit_signer:5/56=9%)
>> > Randy Dunlap <rdunlap@xenotime.net> (commit_signer:3/56=5%)
>>
>> Catalin, Randy since lib/Kconfig.debug has no official maintainer
>> I think this should go up through your trees.
>
> I hadn't seen it until now, but I can merge it.

OK. thanks.
