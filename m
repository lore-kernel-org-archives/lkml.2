Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934796Ab1KJOF4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 09:05:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29483 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934688Ab1KJOFy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 09:05:54 -0500
Message-ID: <4EBBDA3B.9040504@redhat.com>
Date: Thu, 10 Nov 2011 16:05:47 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Xiao Guangrong <xiao.grong@gmail.com>
CC: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 00/11] KVM: x86: optimize for writing guest page
References: <4E7AF758.7060900@cn.fujitsu.com> <20111006175333.GA3959@amt.cnet> <4E8FCC37.8090409@cn.fujitsu.com> <4E91926D.8060206@redhat.com> <4E91A3AA.1000309@redhat.com> <4E940018.1010908@cn.fujitsu.com> <4EB3AD54.9050605@gmail.com> <4EB6A958.9030007@redhat.com> <4EBBD190.2020404@gmail.com>
In-Reply-To: <4EBBD190.2020404@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2011 03:28 PM, Xiao Guangrong wrote:
>
> I have tested RHEL.6.1 setup/boot/reboot/shutdown and the complete
> output of scan_results.py is attached.
>
> The result shows the performance is improved:
> before:            After:
> 570            529
> 555            538
> 552            531
> 546            528
> 553            559
> 553            527
> 550            523
> 553            533
> 547            538
> 550            526
>
> How do you think about it? :)

Well, either I was sloppy in my measurements, or maybe RHEL 6 is very
different from F9 (unlikely).  I'll measure it again and see.

btw, this is with ept=0, yes?

-- 
error compiling committee.c: too many arguments to function

