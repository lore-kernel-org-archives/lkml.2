Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666Ab0DSJWo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 05:22:44 -0400
Received: from mga05.intel.com ([192.55.52.89]:40725 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752067Ab0DSJWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 05:22:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,234,1270450800"; 
   d="scan'208";a="559237473"
Subject: Re: [PATCH V5 1/3] perf & kvm: Enhance perf to collect KVM guest
 os statistics from host side
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       zhiteng.huang@intel.com, tim.c.chen@intel.com,
       Arnaldo Carvalho de Melo <acme@infradead.org>
In-Reply-To: <4BCC1B82.5050000@redhat.com>
References: <1271655161.2078.603.camel@ymzhang.sh.intel.com>
	 <4BCC1665.1080003@redhat.com>
	 <1271667323.2078.611.camel@ymzhang.sh.intel.com>
	 <4BCC1B82.5050000@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Mon, 19 Apr 2010 17:22:21 +0800
Message-Id: <1271668941.2078.613.camel@ymzhang.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-04-19 at 11:59 +0300, Avi Kivity wrote:
> On 04/19/2010 11:55 AM, Zhang, Yanmin wrote:
> > On Mon, 2010-04-19 at 11:37 +0300, Avi Kivity wrote:
> >    
> >> On 04/19/2010 08:32 AM, Zhang, Yanmin wrote:
> >>      
> >>> Below patch introduces perf_guest_info_callbacks and related register/unregister
> >>> functions. Add more PERF_RECORD_MISC_XXX bits meaning guest kernel and guest user
> >>> space.
> >>>
> >>>        
> >> This doesn't apply against upstream.
> >>      
> > What does upstream mean here? The vanilla 2.6.34-rc4?
> >    
> 
> Yes, sorry for being unclear.
> 
> >>    What branch was this generated
> >> against?
> >>
> >>      
> > It's against the latest tip/master. I checked out to 19b26586090 as the latest
> > tip/master has some updates on perf.
> >    
> 
> I don't want to merge tip/master... does tip/perf/core contain the 
> needed updates?
I think so. A moment ago, I checked out to b5a80b7e9 of tip/perf/core. All 3
patches could be applied cleanly and compilation is ok. A quick testing shows
tip/perf/core kernel does work.


