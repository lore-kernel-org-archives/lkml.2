Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758717Ab0FJJux (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 05:50:53 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47705 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008Ab0FJJuw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 05:50:52 -0400
Subject: Re: [RFC] para virt interface of perf to support kvm guest os
 statistics collection in guest os
From: Peter Zijlstra <peterz@infradead.org>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
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
In-Reply-To: <1276136493.2096.462.camel@ymzhang.sh.intel.com>
References: <1276054214.2096.383.camel@ymzhang.sh.intel.com>
	 <4C0F51DD.3080200@redhat.com>
	 <1276075280.2096.427.camel@ymzhang.sh.intel.com>
	 <4C0F61D3.9000402@redhat.com>
	 <1276136493.2096.462.camel@ymzhang.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 10 Jun 2010 11:50:37 +0200
Message-ID: <1276163437.2077.6.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-10 at 10:21 +0800, Zhang, Yanmin wrote:
> . The ABI mostly includes the definition of struct perf_event_attr,
> guest_perf_counter,
> and hypercalls. 

Note that perf_event_attr isn't guaranteed to be stable between kernels,
it can grow.
