Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759208Ab0FVKCk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 06:02:40 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51138 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759095Ab0FVKCh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 06:02:37 -0400
Subject: Re: [PATCH V2 1/5] ara virt interface of perf to support kvm guest
 os statistics collection in guest os
From: Peter Zijlstra <peterz@infradead.org>
To: Avi Kivity <avi@redhat.com>
Cc: Jes Sorensen <Jes.Sorensen@redhat.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Sheng Yang <sheng@linux.intel.com>,
       Marcelo Tosatti <mtosatti@redhat.com>, oerg Roedel <joro@8bytes.org>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       zhiteng.huang@intel.com, tim.c.chen@intel.com
In-Reply-To: <4C20882C.80709@redhat.com>
References: <1277112680.2096.509.camel@ymzhang.sh.intel.com>
	 <4C1F50D0.70205@redhat.com>
	 <1277171344.2096.567.camel@ymzhang.sh.intel.com>
	 <4C2062D8.20609@redhat.com>
	 <1277192873.2096.690.camel@ymzhang.sh.intel.com>
	 <1277193305.1875.537.camel@laptop>  <4C206D8B.4080105@redhat.com>
	 <1277198943.2096.724.camel@ymzhang.sh.intel.com>
	 <1277199060.1875.675.camel@laptop>  <4C2084BB.3040501@redhat.com>
	 <1277200010.1875.692.camel@laptop>  <4C20882C.80709@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 22 Jun 2010 12:02:22 +0200
Message-ID: <1277200942.1875.694.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-22 at 12:53 +0300, Avi Kivity wrote:


> > /me has no clue what virtual MSRs are,
> 
> MSRs that are not defined by the hardware, but instead by the
> hypervisor.
> 
Uhm, but the PMU MSRs are all defined by the hardware, if you move the
PMU MSRs around nothing will work.. *confusion*

> When emulating the hardware PMU we can be clever at times and allow 
> RDPMC not to trap. 

Sure, not disagreeing with that, still the generic case is to trap, so
lets first get that to work and then try and be smart :-)
