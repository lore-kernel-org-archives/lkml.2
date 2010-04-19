Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428Ab0DSKBJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 06:01:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16238 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753245Ab0DSKBH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 06:01:07 -0400
Message-ID: <4BCC29CA.1050305@redhat.com>
Date: Mon, 19 Apr 2010 13:00:42 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       zhiteng.huang@intel.com, tim.c.chen@intel.com,
       Arnaldo Carvalho de Melo <acme@infradead.org>
Subject: Re: [PATCH V5 1/3] perf & kvm: Enhance perf to collect KVM guest
 os statistics from host side
References: <1271655161.2078.603.camel@ymzhang.sh.intel.com>	 <4BCC1665.1080003@redhat.com>	 <1271667323.2078.611.camel@ymzhang.sh.intel.com>	 <4BCC1B82.5050000@redhat.com> <1271668941.2078.613.camel@ymzhang.sh.intel.com>
In-Reply-To: <1271668941.2078.613.camel@ymzhang.sh.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2010 12:22 PM, Zhang, Yanmin wrote:
>
>> I don't want to merge tip/master... does tip/perf/core contain the
>> needed updates?
>>      
> I think so. A moment ago, I checked out to b5a80b7e9 of tip/perf/core. All 3
> patches could be applied cleanly and compilation is ok. A quick testing shows
> tip/perf/core kernel does work.
>
>    

Thanks.  I applied all three patches to the 'perf' branch in kvm.git and 
merged it to master.

Ingo, please pull

   git://git.kernel.org/pub/scm/virt/kvm/kvm.git perf

into tip's perf/core to receive those three patches.

-- 
error compiling committee.c: too many arguments to function

