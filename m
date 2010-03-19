Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762Ab0CSHWa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 03:22:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13012 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751280Ab0CSHW3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 03:22:29 -0400
Message-ID: <4BA3260D.5090407@redhat.com>
Date: Fri, 19 Mar 2010 09:21:49 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Zachary Amsden <zamsden@redhat.com>,
       Anthony Liguori <anthony@codemonkey.ws>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, ziteng.huang@intel.com,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
References: <20100316173940.GA23859@elte.hu> <4BA00F1F.1090907@codemonkey.ws> <20100317081041.GC16374@elte.hu> <4BA1E24B.6090904@redhat.com> <20100318085607.GB2157@elte.hu> <4BA1FC80.2000401@redhat.com> <20100318105013.GB24464@elte.hu> <4BA294D4.2060700@redhat.com> <20100318211529.GA21367@elte.hu> <4BA2A70B.5080101@redhat.com> <20100318224446.GC19669@elte.hu>
In-Reply-To: <20100318224446.GC19669@elte.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2010 12:44 AM, Ingo Molnar wrote:
>
> Too bad - there was heavy initial opposition to the arch/x86 unification as
> well [and heavy opposition to tools/perf/ as well], still both worked out
> extremely well :-)
>    

Did you forget that arch/x86 was a merging of a code fork that happened 
several years previously?  Maybe that fork shouldn't have been done to 
begin with.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

