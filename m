Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167Ab2FMHoT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 03:44:19 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:42532 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797Ab2FMHoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 03:44:17 -0400
Date: Wed, 13 Jun 2012 09:44:12 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>,
        Stephane Eranian <eranian@google.com>, a.p.zijlstra@chello.nl,
        mingo@elte.hu, jolsa@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V5 0/13] perf: Intel uncore pmu counting support
Message-ID: <20120613074412.GB8057@gmail.com>
References: <1339479468-3815-1-git-send-email-zheng.z.yan@intel.com>
 <CABPqkBQu1hTa2R-PKsygLqOSSD9nu3+xR-79pT-8bB8Y16CBuw@mail.gmail.com>
 <4FD7EFCB.6060005@intel.com>
 <m2obonj3a7.fsf@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m2obonj3a7.fsf@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> "Yan, Zheng" <zheng.z.yan@intel.com> writes:
> 
> > Peter suggests keeping the uncore names as they're listed in the intel
> > doc. For Sandybirdge-EP, uncore names are something like: Cbo, iMC, QPI.
> > I think Uncore_Cbo_0 appears better than uncore_Cbo_0
> 
> How about a case insensitive match for the sysfs directories? 
> [...]

That's idiotic, avoidable lookup complexity.

> [...] That can be implemented in user land with nftw(). Since 
> sysfs is all virtual it should not be too expensive, as long 
> as you only walk the pmu parts.
> 
> I think that would be most user friendly.

It would be most idiotic, stop suggesting crap.

Why not rot13 it as well? Could be decoded in user-space as well 
with some helpers. Hey, md5 checksum it too.

Thanks,

	Ingo
