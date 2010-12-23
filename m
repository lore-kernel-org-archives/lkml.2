Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599Ab0LWKDe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 05:03:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24253 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752373Ab0LWKDd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 05:03:33 -0500
Message-ID: <4D131DEA.4050206@redhat.com>
Date: Thu, 23 Dec 2010 18:01:14 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>,
        WANG Cong <xiyou.wangcong@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Dan Carpenter <error27@gmail.com>, Tejun Heo <tj@kernel.org>,
        Eugene Teo <eugene@redhat.com>
Subject: Re: [RFC Patch] kcore: restrict access to the whole memory
References: <1293016926-1714-1-git-send-email-amwang@redhat.com> <20101222150209.8e18afa7.akpm@linux-foundation.org>
In-Reply-To: <20101222150209.8e18afa7.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2010年12月23日 07:02, Andrew Morton 写道:
> On Wed, 22 Dec 2010 19:21:59 +0800
> Amerigo Wang<amwang@redhat.com>  wrote:
>
>> This patch restricts /proc/kcore from accessing the whole memory,
>> instead, only an ELF header can be read.
>>
>> The initial patch was done by Vivek.
>
> Getting a bit tired of this.
>
> Are we supposed to be mind-readers?  How else are we to work out why
> you think Linux needs this feature?  What problems it solves?  What
> applications are expected to break and what the breakage patterns are?
> Why the benefits are worth the maintenance costs and the risk of
> breakage?  Why it's done with a config option and not a boot-time or
> runtime tunable?
>

Oh, sorry, I forgot to mention this is for security reasons,
I am adding Eugene into Cc so that he can explain more about this.

Yeah, I thought about sysctl too, but it is really weird for me
to control /proc/kcore contents via an sysctl file, I think
an Kconfig is enough.

Thanks!
