Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365Ab0CRNLU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 09:11:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58722 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753280Ab0CRNLT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 09:11:19 -0400
Message-ID: <4BA22663.7070509@redhat.com>
Date: Thu, 18 Mar 2010 15:10:59 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Frank Ch. Eigler" <fche@redhat.com>, Alexander Graf <agraf@suse.de>,
       Anthony Liguori <anthony@codemonkey.ws>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
References: <20100316173940.GA23859@elte.hu> <4BA00F1F.1090907@codemonkey.ws> <20100317081041.GC16374@elte.hu> <4BA1E24B.6090904@redhat.com> <20100318085607.GB2157@elte.hu> <F0F75B33-C0BA-42EB-BFC4-D60B1E232E6D@suse.de> <20100318101025.GA13073@elte.hu> <4BA1FEB0.7000400@redhat.com> <20100318113527.GA13168@elte.hu> <y0m4okdzu4z.fsf@fche.csb> <20100318130226.GB7424@elte.hu>
In-Reply-To: <20100318130226.GB7424@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/2010 03:02 PM, Ingo Molnar wrote:
>
>> [...] What users eagerly replace their kernels?
>>      
> Those 99% who click on the 'install 193 updates' popup.
>
>    

Of which 1 is the kernel, and 192 are userspace updates (of which one 
may be qemu).

-- 
error compiling committee.c: too many arguments to function

