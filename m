Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758548Ab0FVIAs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 04:00:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31820 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755081Ab0FVIAq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 04:00:46 -0400
Message-ID: <4C206D8B.4080105@redhat.com>
Date: Tue, 22 Jun 2010 10:00:11 +0200
From: Jes Sorensen <Jes.Sorensen@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       kvm@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Sheng Yang <sheng@linux.intel.com>,
       Marcelo Tosatti <mtosatti@redhat.com>, oerg Roedel <joro@8bytes.org>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       zhiteng.huang@intel.com, tim.c.chen@intel.com
Subject: Re: [PATCH V2 1/5] ara virt interface of perf to support kvm guest
 os statistics collection in guest os
References: <1277112680.2096.509.camel@ymzhang.sh.intel.com>	 <4C1F50D0.70205@redhat.com>	 <1277171344.2096.567.camel@ymzhang.sh.intel.com>	 <4C2062D8.20609@redhat.com>	 <1277192873.2096.690.camel@ymzhang.sh.intel.com> <1277193305.1875.537.camel@laptop>
In-Reply-To: <1277193305.1875.537.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22/10 09:55, Peter Zijlstra wrote:
> On Tue, 2010-06-22 at 15:47 +0800, Zhang, Yanmin wrote:
>> Besides the para virt perf interface, I'm also considering the direct exposition
>> of PMU hardware to guest os. 
> 
> NAK NAK NAK NAK, we've been over that, its not going to happen, full
> stop!
> 
> Use MSR read/write traps and host perf to emulate the hardware. In some
> cases we could allow the reads without trap but that's a later
> optimization.

I believe whats meant here is a PMU compatible interface which is
partially emulated. Not a handover of the PMU.

Jes
