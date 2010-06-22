Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758421Ab0FVHz0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 03:55:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:37298 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809Ab0FVHzY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 03:55:24 -0400
Subject: Re: [PATCH V2 1/5] ara virt interface of perf to support kvm guest
 os statistics collection in guest os
From: Peter Zijlstra <peterz@infradead.org>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Jes Sorensen <Jes.Sorensen@redhat.com>, Avi Kivity <avi@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Sheng Yang <sheng@linux.intel.com>,
       Marcelo Tosatti <mtosatti@redhat.com>, oerg Roedel <joro@8bytes.org>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       zhiteng.huang@intel.com, tim.c.chen@intel.com
In-Reply-To: <1277192873.2096.690.camel@ymzhang.sh.intel.com>
References: <1277112680.2096.509.camel@ymzhang.sh.intel.com>
	 <4C1F50D0.70205@redhat.com>
	 <1277171344.2096.567.camel@ymzhang.sh.intel.com>
	 <4C2062D8.20609@redhat.com>
	 <1277192873.2096.690.camel@ymzhang.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 22 Jun 2010 09:55:05 +0200
Message-ID: <1277193305.1875.537.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-22 at 15:47 +0800, Zhang, Yanmin wrote:
> Besides the para virt perf interface, I'm also considering the direct exposition
> of PMU hardware to guest os. 

NAK NAK NAK NAK, we've been over that, its not going to happen, full
stop!

Use MSR read/write traps and host perf to emulate the hardware. In some
cases we could allow the reads without trap but that's a later
optimization.
