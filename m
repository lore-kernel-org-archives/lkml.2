Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756501Ab1EFNrs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 09:47:48 -0400
Received: from mga09.intel.com ([134.134.136.24]:1197 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756475Ab1EFNrq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 09:47:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,326,1301900400"; 
   d="scan'208";a="743314931"
Subject: Re: [PATCH] perf events, x86: Implement Sandybridge last-level
 cache events
From: Lin Ming <ming.m.lin@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Mike Galbraith <efault@gmx.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <20110506091950.GA5081@elte.hu>
References: <1304666042-17577-1-git-send-email-ming.m.lin@intel.com>
	 <20110506073832.GG23166@elte.hu>  <20110506091950.GA5081@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 06 May 2011 21:47:47 +0800
Message-Id: <1304689667.2200.3.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-06 at 17:19 +0800, Ingo Molnar wrote:
> Btw., there's another missing Intel SandyBridge related perf events feature as 
> well which was not implemented with the Intel offcore bits.
> 
> Peter did a raw first cut - entirely untested, see it below. Would you be 
> interested in testing it on Intel SandyBridge hw and sending (the working 
> version) to lkml with your Signed-off-by if the events looks good to you in 
> some real tests (i.e. are counting real LL cache events)?

OK, but I can't access SandyBridge machine at home now.
Will try it next Monday.

> 
> Thanks,
> 
> 	Ingo


