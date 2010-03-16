Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937730Ab0CPKut (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 06:50:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33129 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937713Ab0CPKus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 06:50:48 -0400
Date: Tue, 16 Mar 2010 11:50:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com
Subject: Re: [PATCH] Enhance perf to collect KVM guest os statistics from
 host side
Message-ID: <20100316105021.GA14344@elte.hu>
References: <1268717232.2813.36.camel@localhost>
 <4B9F19F7.6000309@redhat.com>
 <20100316072449.GB11881@elte.hu>
 <4B9F4D74.4090403@redhat.com>
 <20100316095336.GI7961@elte.hu>
 <4B9F59DE.1060008@redhat.com>
 <20100316102052.GC10069@elte.hu>
 <4B9F603B.4080004@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B9F603B.4080004@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Avi Kivity <avi@redhat.com> wrote:

> On 03/16/2010 12:20 PM, Ingo Molnar wrote:
> >>>>
> >>>>The symbol server's client can certainly access the bits through vmchannel.
> >>>Ok, that would work i suspect.
> >>>
> >>>Would be nice to have the symbol server in tools/perf/ and also make it easy
> >>>to add it to the initrd via a .config switch or so.
> >>>
> >>>That would have basically all of the advantages of being built into the kernel
> >>>(availability, configurability, transparency, hackability), while having all
> >>>the advantages of a user-space approach as well (flexibility, extensibility,
> >>>robustness, ease of maintenance, etc.).
> >>Note, I am not advocating building the vmchannel client into the host
> >>kernel. [...]
> >Neither am i. What i suggested was a user-space binary/executable built in
> >tools/perf and put into the initrd.
> 
> I'm confused - initrd seems to be guest-side.  I was talking about the host 
> side.

host side doesnt need much support - just some client capability in perf 
itself. I suspect vmchannels are sufficiently flexible and configuration-free 
for such purposes? (i.e. like a filesystem in essence)

	Ingo
