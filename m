Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932599Ab1C3PYY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 11:24:24 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:53363 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754659Ab1C3PYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 11:24:22 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=m/aSmFwKW6/HdZoTQcETdqlWWyGFj5NF7buc+r/mJ9kSFJJajxzq67lv6pdwS4jBbcJ/8PUXAwiYWDQuxqtPLZIXj6pJNnst3IiNxtulR6DKnRVEBwhhJppEfgBawT9p;
Date: Wed, 30 Mar 2011 08:24:19 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Daniel Baluta <daniel.baluta@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, paulmck@linux.vnet.ibm.com,
        akpm@linux-foundation.org, mingo@elte.hu, fweisbec@gmail.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        penberg@kernel.org
Subject: Re: [PATCH] kmemleak: build kmemleak-test.c as a module-only
Message-Id: <20110330082419.b782fa94.rdunlap@xenotime.net>
In-Reply-To: <AANLkTim3-6vrS8uEEm+jsuSJ64z_Edq40+MqF-m2ve5=@mail.gmail.com>
References: <1300299394-20844-1-git-send-email-dbaluta@ixiacom.com>
	<1300879469.23962.40.camel@e102109-lin.cambridge.arm.com>
	<AANLkTik-LbTo6TcdBuJxg7sGmPX-0tpiZHwgHRWBQc_f@mail.gmail.com>
	<AANLkTim3-6vrS8uEEm+jsuSJ64z_Edq40+MqF-m2ve5=@mail.gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 173.50.240.230 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Mar 2011 18:02:02 +0300 Daniel Baluta wrote:

> On Fri, Mar 25, 2011 at 4:05 PM, Daniel Baluta <dbaluta@ixiacom.com> wrote:
> > On Wed, Mar 23, 2011 at 1:24 PM, Catalin Marinas
> > <catalin.marinas@arm.com> wrote:
> >> On Wed, 2011-03-16 at 18:16 +0000, Daniel Baluta wrote:
> >>> mm/kmemleak-test.c is used to provide an example of how kmemleak
> >>> tool works.
> >>>
> >>> Memory is leaked at module unload-time, so building the test
> >>> in kernel (Y) makes the leaks impossible and the test useless.
> >>>
> >>> Qualify DEBUG_KMEMLEAK_TEST config symbol with "depends on m",
> >>> to restrict module-only building.
> >>>
> >>> Signed-off-by: Daniel Baluta <dbaluta@ixiacom.com>
> >>
> >> Sorry for the delay.
> >>
> >> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> >
> > Who should pick this up?
> >
> > $ scripts/get_maintainer.pl lib/this.patch says:
> > Andrew Morton <akpm@linux-foundation.org> (commit_signer:8/56=14%)
> > "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> (commit_signer:7/56=12%)
> > Ingo Molnar <mingo@elte.hu> (commit_signer:5/56=9%)
> > Frederic Weisbecker <fweisbec@gmail.com> (commit_signer:5/56=9%)
> > Randy Dunlap <rdunlap@xenotime.net> (commit_signer:3/56=5%)
> 
> Catalin, Randy since lib/Kconfig.debug has no official maintainer
> I think this should go up through your trees.

I hadn't seen it until now, but I can merge it.

thanks.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
