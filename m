Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752533Ab2GIQq5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 12:46:57 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:48747 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203Ab2GIQqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 12:46:55 -0400
Message-ID: <4FFB0AF7.1080604@hp.com>
Date: Mon, 09 Jul 2012 09:46:47 -0700
From: Rick Jones <rick.jones2@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Jason Wang <jasowang@redhat.com>
CC: mst@redhat.com, mashirle@us.ibm.com, krkumar2@in.ibm.com,
        habanero@linux.vnet.ibm.com, rusty@rustcorp.com.au,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, edumazet@google.com,
        tahm@linux.vnet.ibm.com, jwhan@filewood.snu.ac.kr, davem@davemloft.net,
        akong@redhat.com, kvm@vger.kernel.org, sri@us.ibm.com
Subject: Re: [net-next RFC V5 0/5] Multiqueue virtio-net
References: <1341484194-8108-1-git-send-email-jasowang@redhat.com> <4FF5D2B7.6080602@hp.com> <4FF696C9.5070907@redhat.com> <4FF710FD.2090100@hp.com> <4FFA4EAD.7000707@redhat.com>
In-Reply-To: <4FFA4EAD.7000707@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/2012 08:23 PM, Jason Wang wrote:
> On 07/07/2012 12:23 AM, Rick Jones wrote:
>> On 07/06/2012 12:42 AM, Jason Wang wrote:
>> Which mechanism to address skew error?  The netperf manual describes
>> more than one:
>
> This mechanism is missed in my test, I would add them to my test scripts.
>>
>> http://www.netperf.org/svn/netperf2/trunk/doc/netperf.html#Using-Netperf-to-Measure-Aggregate-Performance
>>
>>
>> Personally, my preference these days is to use the "demo mode" method
>> of aggregate results as it can be rather faster than (ab)using the
>> confidence intervals mechanism, which I suspect may not really scale
>> all that well to large numbers of concurrent netperfs.
>
> During my test, the confidence interval would even hard to achieved in
> RR test when I pin vhost/vcpus in the processors, so I didn't use it.

When running aggregate netperfs, *something* has to be done to address 
the prospect of skew error.  Otherwise the results are suspect.

happy benchmarking,

rick jones
