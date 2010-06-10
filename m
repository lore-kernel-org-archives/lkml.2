Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003Ab0FJFL2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 01:11:28 -0400
Received: from mga14.intel.com ([143.182.124.37]:11854 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753766Ab0FJFLY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 01:11:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,396,1272870000"; 
   d="scan'208";a="287177932"
Subject: Re: [RFC] para virt interface of perf to support kvm guest os
 statistics collection in guest os
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Avi Kivity <avi@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Sheng Yang <sheng@linux.intel.com>,
       Marcelo Tosatti <mtosatti@redhat.com>, oerg Roedel <joro@8bytes.org>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>, zhiteng.huang@intel.com,
       tim.c.chen@intel.com, Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <4C10569E.6020503@redhat.com>
References: <1276054214.2096.383.camel@ymzhang.sh.intel.com>
	 <4C0F51DD.3080200@redhat.com>
	 <1276075280.2096.427.camel@ymzhang.sh.intel.com>
	 <4C0F61D3.9000402@redhat.com>
	 <1276136493.2096.462.camel@ymzhang.sh.intel.com>
	 <4C10569E.6020503@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Thu, 10 Jun 2010 13:13:31 +0800
Message-Id: <1276146811.2096.463.camel@ymzhang.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-10 at 06:06 +0300, Avi Kivity wrote:
> On 06/10/2010 05:21 AM, Zhang, Yanmin wrote:
> >
> >> I see.  So put it in a union.  Or perhaps not even in a union - what if
> >> a kvm guest is also acting as a kvm host?
> >>      
> > My patch has consideration on it. I compiled kernel with host and guest support
> > at the same time. The accessing to perf_event->shadow is really under specific
> > scenarios, or they are just in specific functions. These functions are called
> > just bu host kernel , or just by guest kernel.
> >    
> 
> But a kernel can be both guest and host at the same time.  Currently 
> this only works on AMD, but there was some work to bring it to Intel as 
> well.
Oh, this is a fancy VT feature. My patch doesn't support this mode.

