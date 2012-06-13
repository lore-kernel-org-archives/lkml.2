Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751185Ab2FMHix (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 03:38:53 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:62610 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727Ab2FMHiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 03:38:51 -0400
Date: Wed, 13 Jun 2012 09:38:46 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Stephane Eranian <eranian@google.com>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, a.p.zijlstra@chello.nl,
        mingo@elte.hu, jolsa@redhat.com, andi@firstfloor.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V5 0/13] perf: Intel uncore pmu counting support
Message-ID: <20120613073846.GA8057@gmail.com>
References: <1339479468-3815-1-git-send-email-zheng.z.yan@intel.com>
 <CABPqkBQu1hTa2R-PKsygLqOSSD9nu3+xR-79pT-8bB8Y16CBuw@mail.gmail.com>
 <4FD7EFCB.6060005@intel.com>
 <CABPqkBQmdyfxJ1iFoGt45c84zzzUphosY8Qg76MACX=xdtk_mw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBQmdyfxJ1iFoGt45c84zzzUphosY8Qg76MACX=xdtk_mw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephane Eranian <eranian@google.com> wrote:

> > Peter suggests keeping the uncore names as they're listed in 
> > the intel doc. For Sandybirdge-EP, uncore names are 
> > something like: Cbo, iMC, QPI. I think Uncore_Cbo_0 appears 
> > better than uncore_Cbo_0
>
> Keeping the name is different from keeping the upper vs. lower 
> case letters. I think this need to be case insensitive. What 
> does it buy you to be case sensitive? Don't think Intel is 
> ever going to create two events which differ only by the lower 
> vs. upper case. And, I think that's extra frustration when you 
> type the event name because you have to also remember the 
> letter case.

Yeah - the right approach is to make it all lowercase in sysfs - 
then user-space can tolower() the string provided by the user.

There should be no case sensitivity in event specifications 
anywhere.

Thanks,

	Ingo
