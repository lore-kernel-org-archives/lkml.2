Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097Ab0IAJGs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 05:06:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5323 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751274Ab0IAJGp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 05:06:45 -0400
Message-ID: <4C7E179D.6000405@redhat.com>
Date: Wed, 01 Sep 2010 12:06:37 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Thunderbird/3.1.2
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 5/5] KVM: MMU: lower the aduit frequency
References: <4C78FA00.8090606@cn.fujitsu.com> <4C7B867D.9080500@cn.fujitsu.com> <4C7B8759.60900@cn.fujitsu.com> <20100830154719.GB12707@amt.cnet> <4C7C687D.2000401@cn.fujitsu.com>
In-Reply-To: <4C7C687D.2000401@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 08/31/2010 05:27 AM, Xiao Guangrong wrote:
>
>> I've always seen progress from the guest while running with audit
>> enabled (its slow, but its not supposed to be fast anyway).
>>
>> Did you experience a freeze?
>>
> There is a simply test in the guest if it's not rate limit:
>
> # time ls
> anaconda-ks.cfg  Documents  install.log         Music     Public     Videos
> Desktop          Downloads  install.log.syslog  Pictures  Templates
>
> real    1m26.053s
> user    0m0.311s
> sys     0m1.813s
>
> 'ls' command cost about 1.5 minute, if we run the memory test program, i think
> the time/delay is unacceptable...... :-(

Marcelo, would making the ratelimit optional help?  personally I think 
without ratelimit audit is useless, and with ratelimit it is a lot less 
useful but can still point out problems.  But I haven't used it in a while.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

