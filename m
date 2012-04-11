Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760Ab2DKMvy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 08:51:54 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:54532 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470Ab2DKMvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 08:51:53 -0400
Message-ID: <4F857B61.9080602@linux.vnet.ibm.com>
Date: Wed, 11 Apr 2012 20:38:57 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 00/13] KVM: MMU: fast page fault
References: <4F742951.7080003@linux.vnet.ibm.com> <4F82E04E.6000900@redhat.com>	<20120409175829.GB21894@amt.cnet> <4F8329D3.7000605@gmail.com>	<20120409194614.GB23053@amt.cnet> <4F840DD2.3090101@redhat.com> <20120410204031.ffb5b976225ac9fe6dae474e@gmail.com> <4F842074.1050108@linux.vnet.ibm.com> <20120411211514.35db29c11460516e604059b6@gmail.com>
In-Reply-To: <20120411211514.35db29c11460516e604059b6@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12041112-8878-0000-0000-000001FFE6A7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2012 08:15 PM, Takuya Yoshikawa wrote:

> On Tue, 10 Apr 2012 19:58:44 +0800
> Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com> wrote:
> 
>> No, i do not really agree with that.
>>
>> We really can get great benefit from O(1) especially if lockless write-protect
>> is introduced for O(1), live migration is very useful for cloud computing
>> architecture to balance the overload on all nodes.
> 
> Recently, you said to me that you were not familiar with live migration.
> Actually you did not know the basics of pre-copy live migration.
> 
> I know live migration better than you because NTT has Kemari and it uses
> live migration infrastructure.  My work is originated from the data
> I got during profiling Kemari.


Well, my point is that live migration is so very useful that it is worth
to be improved, the description of your also proves this point.

What is your really want to say but i missed?

> 
> SRCU-less dirty logging was also motivated by the pressures from scheduler
> developers.  Everything was really needed.
> 


Totally agree, please note, i did not negate your contribution on dirty
logging at all.

> 
> Have you ever used live migration for real service?
> 


I should admit that you are better at live migration, but it does not
hinder our discussion. If you think i was wrong, welcome to correct me
at any time.

> I cannot say whether O(1) is OK with me without any real background.
> 


Okay, let us to compare the performance number after O(1) implemented.

