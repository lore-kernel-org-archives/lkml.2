Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760071Ab0FKCJf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 22:09:35 -0400
Received: from mga01.intel.com ([192.55.52.88]:14849 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754499Ab0FKCJd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 22:09:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,401,1272870000"; 
   d="scan'208";a="575337186"
Subject: Re: [RFC] para virt interface of perf to support kvm guest os
 statistics collection in guest os
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       kvm@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Sheng Yang <sheng@linux.intel.com>,
       Marcelo Tosatti <mtosatti@redhat.com>, oerg Roedel <joro@8bytes.org>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>, zhiteng.huang@intel.com,
       tim.c.chen@intel.com
In-Reply-To: <1276163437.2077.6.camel@twins>
References: <1276054214.2096.383.camel@ymzhang.sh.intel.com>
	 <4C0F51DD.3080200@redhat.com>
	 <1276075280.2096.427.camel@ymzhang.sh.intel.com>
	 <4C0F61D3.9000402@redhat.com>
	 <1276136493.2096.462.camel@ymzhang.sh.intel.com>
	 <1276163437.2077.6.camel@twins>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Fri, 11 Jun 2010 10:11:43 +0800
Message-Id: <1276222303.2096.466.camel@ymzhang.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-10 at 11:50 +0200, Peter Zijlstra wrote:
> On Thu, 2010-06-10 at 10:21 +0800, Zhang, Yanmin wrote:
> > . The ABI mostly includes the definition of struct perf_event_attr,
> > guest_perf_counter,
> > and hypercalls. 
> 
> Note that perf_event_attr isn't guaranteed to be stable between kernels,
> it can grow.
Thanks. I need create a small new attr structure to save some key data members.

