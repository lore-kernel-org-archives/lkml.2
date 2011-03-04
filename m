Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759086Ab1CDBQe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 20:16:34 -0500
Received: from mga14.intel.com ([143.182.124.37]:48939 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758917Ab1CDBQd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 20:16:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,261,1297065600"; 
   d="scan'208";a="397311641"
Subject: Re: [PATCH v3 0/4] perf: offcore event monitoring patches
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1299147297.1310.50.camel@laptop>
References: <1299119690-13991-1-git-send-email-ming.m.lin@intel.com>
	 <1299147297.1310.50.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Mar 2011 09:16:37 +0800
Message-ID: <1299201397.2908.0.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-03 at 18:14 +0800, Peter Zijlstra wrote:
> On Thu, 2011-03-03 at 10:34 +0800, Lin Ming wrote:
> 
> > Peter,
> > The event scheduling issue was fixed, could you please consider merging
> > this series?
> 
> I'll have a look today.
> 
> BTW, you managed to wreck git-send-email, you have git 1.7 which does
> the right thing by default (--no-chain-reply-to), please do use that. I
> normally ignore emails send like this.

OK. Will use --no-chain-reply-to next time.


