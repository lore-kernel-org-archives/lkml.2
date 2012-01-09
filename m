Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933586Ab2AIXxM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 18:53:12 -0500
Received: from mga09.intel.com ([134.134.136.24]:61135 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932158Ab2AIXxL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 18:53:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="94583776"
Subject: Re: [PATCH] x86,sched: Fix sched_smt_power_savings totally broken
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Youquan Song <youquan.song@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
        akpm@linux-foundation.org, stable@vger.kernel.org,
        arjan@linux.intel.com, len.brown@intel.com, anhua.xu@intel.com,
        chaohong.guo@intel.com, Youquan Song <youquan.song@linux.intel.com>
In-Reply-To: <20120110055856.GA23741@linux-youquan.bj.intel.com>
References: <1326099367-4166-1-git-send-email-youquan.song@intel.com>
	 <1326103578.2442.50.camel@twins>
	 <20120110001445.GA20542@linux-youquan.bj.intel.com>
	 <1326107156.2442.59.camel@twins>
	 <20120110055856.GA23741@linux-youquan.bj.intel.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel
Date: Mon, 09 Jan 2012 15:52:43 -0800
Message-ID: <1326153163.2366.7.camel@sbsiddha-mobl2>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-01-10 at 00:58 -0500, Youquan Song wrote:
> Thanks Peter! Here is the patch. 

Youquan, As far as I know both the
sched_smt_power_savings/sched_mc_power_savings are broken for atleast an
year.

Have you checked the state of 'sched_mc_power_savings' to see if it is
working or gets addressed with your proposed patches?

thanks,
suresh

