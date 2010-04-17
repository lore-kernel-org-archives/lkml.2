Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756804Ab0DQKtr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Apr 2010 06:49:47 -0400
Received: from 8bytes.org ([88.198.83.132]:48193 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756325Ab0DQKtp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Apr 2010 06:49:45 -0400
Date: Sat, 17 Apr 2010 12:49:44 +0200
From: Joerg Roedel <joro@8bytes.org>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>,
       Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
       Jes Sorensen <Jes.Sorensen@redhat.com>, linux-kernel@vger.kernel.org,
       Zachary Amsden <zamsden@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       tim.c.chen@intel.com, zhiteng.huang@intel.com,
       Arnaldo Carvalho de Melo <acme@infradead.org>
Subject: Re: [PATCH V4 1/2] perf & kvm: Enhance perf to collect KVM guest
	os statistics from host side
Message-ID: <20100417104944.GB23260@8bytes.org>
References: <1271403275.2078.509.camel@ymzhang.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271403275.2078.509.camel@ymzhang.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yanmin,

On Fri, Apr 16, 2010 at 03:34:35PM +0800, Zhang, Yanmin wrote:
> Below is the kernel patch to enable perf to collect guest os statistics.
> 
> Joerg,
> 
> Would you like to add support on svm? I don't know the exact point to trigger
> NMI to host with svm.

Yes I will do that, thanks for all the work you have already done :-) Do
we have a branch for that work somewhere? Probably in the -tip tree? 

	Joerg

