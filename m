Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986Ab0DSIZm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 04:25:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49405 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751535Ab0DSIZk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 04:25:40 -0400
Message-ID: <4BCC136D.503@redhat.com>
Date: Mon, 19 Apr 2010 11:25:17 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Sheng Yang <sheng@linux.intel.com>
CC: Joerg Roedel <joro@8bytes.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>, zhiteng.huang@intel.com,
       tim.c.chen@intel.com, Arnaldo Carvalho de Melo <acme@infradead.org>
Subject: Re: [PATCH V3] perf & kvm: Enhance perf to collect KVM guest  os
 statistics from host side
References: <1902387910.2078.435.camel@ymzhang.sh.intel.com> <20100415104051.GC12697@8bytes.org> <4BC6EDFF.3000702@redhat.com> <201004152208.08409.sheng@linux.intel.com> <4BC9FA19.2070602@redhat.com>
In-Reply-To: <4BC9FA19.2070602@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2010 09:12 PM, Avi Kivity wrote:
>
> I think you were right the first time around.
>

Re-reading again (esp. the part about treatment of indirect NMI 
vmexits), I think this was wrong, and that the code is correct.  I am 
now thoroughly confused.


-- 
error compiling committee.c: too many arguments to function

