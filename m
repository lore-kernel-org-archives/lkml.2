Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738Ab1CEOPP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 09:15:15 -0500
Received: from mga09.intel.com ([134.134.136.24]:62055 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751201Ab1CEOPO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 09:15:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,269,1297065600"; 
   d="scan'208";a="609413209"
Subject: Re: [RFC -tip] perf, x86: P4 PMU -- Address erratum 15 and 17
From: Lin Ming <ming.m.lin@intel.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Robert Richter <robert.richter@amd.com>,
        lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <4D7141FC.8000504@gmail.com>
References: <4D7141FC.8000504@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 05 Mar 2011 22:14:47 +0800
Message-Id: <1299334487.2324.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-03-05 at 03:48 +0800, Cyrill Gorcunov wrote:
> Errata N15 and 17 of 249199-071 should be taken
> into account. They are mostly hard to hit at moment
> i believe but still better to be fixed.
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> ---
> 
> Ming, mind to give it a shot? I seems will be able to test myself
> at Wednesday only. And I would like to get a review first to eliminate
> some silly mistakes ;)

I'll test this next Monday when I back to office.

Thanks.

> 
>  arch/x86/kernel/cpu/perf_event_p4.c |   54 ++++++++++++++++++++++++++++++++++--
>  1 file changed, 51 insertions(+), 3 deletions(-)


