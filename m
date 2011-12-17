Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760756Ab1LQCFx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 21:05:53 -0500
Received: from mga14.intel.com ([143.182.124.37]:60239 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760643Ab1LQCFq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 21:05:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="86663301"
Subject: Re: Latest tip kernel(3.2-rc1-tip_cf6b3899) fails to boot on
 x3850x5 machine
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>,
        Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Date: Fri, 16 Dec 2011 18:10:34 -0800
In-Reply-To: <20111216083634.GA4170@elte.hu>
References: <87ehw7ig2v.fsf@abhimanyu.in.ibm.com>
	 <alpine.LFD.2.02.1112141423380.3020@ionos>
	 <alpine.LFD.2.02.1112142116540.3020@ionos>
	 <CAE9FiQXz6n=2gR1CY29pEbfbwx-e27WrUoDQeH9qxmL_kwP+mA@mail.gmail.com>
	 <87y5ueo9m5.fsf@abhimanyu.in.ibm.com>
	 <CAE9FiQXL3N6UZ6REfdUT_o1b-ed_KnYqKm_wSEhsaRPeaE9-9Q@mail.gmail.com>
	 <20111215071901.GF14237@elte.hu>
	 <CAE9FiQXh8tiJ0Aa80uGJBiVv_3-rirMt1roQwZ3dBws-p0=j9A@mail.gmail.com>
	 <1323980706.1984.255.camel@sbsiddha-desk.sc.intel.com>
	 <20111216083634.GA4170@elte.hu>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1324087834.1984.299.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-12-16 at 00:36 -0800, Ingo Molnar wrote:
> The problem is spuriously re-asking a question that *has already 
> been answered by the user*, and if the user accidentally just 
> accepts the default, the config breaks.
> 
> We try to keep things working fine across 'make oldconfig', i.e. 
> if the .config worked before, it should work after a 'make 
> oldconfig' as well.
> 

Ok. So what is the recommended way to do this, for example when we
change a config option name with no other dependency changes etc?

thanks,
suresh

