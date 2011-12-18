Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751536Ab1LRIej (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 03:34:39 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41703 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750979Ab1LRIeh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 03:34:37 -0500
Date: Sun, 18 Dec 2011 09:32:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Yinghai Lu <yinghai@kernel.org>,
        Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: Latest tip kernel(3.2-rc1-tip_cf6b3899) fails to boot on x3850x5
 machine
Message-ID: <20111218083245.GE4144@elte.hu>
References: <alpine.LFD.2.02.1112141423380.3020@ionos>
 <alpine.LFD.2.02.1112142116540.3020@ionos>
 <CAE9FiQXz6n=2gR1CY29pEbfbwx-e27WrUoDQeH9qxmL_kwP+mA@mail.gmail.com>
 <87y5ueo9m5.fsf@abhimanyu.in.ibm.com>
 <CAE9FiQXL3N6UZ6REfdUT_o1b-ed_KnYqKm_wSEhsaRPeaE9-9Q@mail.gmail.com>
 <20111215071901.GF14237@elte.hu>
 <CAE9FiQXh8tiJ0Aa80uGJBiVv_3-rirMt1roQwZ3dBws-p0=j9A@mail.gmail.com>
 <1323980706.1984.255.camel@sbsiddha-desk.sc.intel.com>
 <20111216083634.GA4170@elte.hu>
 <1324087834.1984.299.camel@sbsiddha-desk.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324087834.1984.299.camel@sbsiddha-desk.sc.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> On Fri, 2011-12-16 at 00:36 -0800, Ingo Molnar wrote:
> > The problem is spuriously re-asking a question that *has already 
> > been answered by the user*, and if the user accidentally just 
> > accepts the default, the config breaks.
> > 
> > We try to keep things working fine across 'make oldconfig', i.e. 
> > if the .config worked before, it should work after a 'make 
> > oldconfig' as well.
> > 
> 
> Ok. So what is the recommended way to do this, for example when we
> change a config option name with no other dependency changes etc?

Firstly, we try hard not to change existing config option names 
if possible :-)

Now that it's done i doubt there's any real good option left: 
some people have the old config, some have the new. We'll see 
how many others are affected, if it's widespread we can 
reintroduce the old option or just default-on the feature if 
there's some other related feature that was not renamed.

Thanks,

	Ingo
