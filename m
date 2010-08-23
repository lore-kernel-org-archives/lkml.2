Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752385Ab0HWL3E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 07:29:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58916 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751904Ab0HWL27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 07:28:59 -0400
Message-ID: <4C725B75.9000106@redhat.com>
Date: Mon, 23 Aug 2010 14:28:53 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Xiaotian Feng <xtfeng@gmail.com>
CC: Tim Pepper <lnxninja@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org
Subject: Re: [PATCH 0/4 v2] kvm: rework KVM mmu_shrink() code
References: <20100820011054.GA11297@tpepper-t61p.dolavim.us>	<4C724BDB.8020604@redhat.com>	<4C724D13.6000807@redhat.com> <AANLkTi=7HdLqm-g1F+ezhDN4n+vPo2jAo2cgn-M6_wMJ@mail.gmail.com>
In-Reply-To: <AANLkTi=7HdLqm-g1F+ezhDN4n+vPo2jAo2cgn-M6_wMJ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 08/23/2010 02:11 PM, Xiaotian Feng wrote:
> On Mon, Aug 23, 2010 at 6:27 PM, Avi Kivity<avi@redhat.com>  wrote:
>>   On 08/23/2010 01:22 PM, Avi Kivity wrote:
>>>
>>> I see a lot of soft lockups with this patchset:
>> This is running the emulator.flat test case, with shadow paging.  This test
>> triggers a lot (millions) of mmu mode switches.
>>
> Does following patch fix your issue?
>

It does indeed!

-- 
error compiling committee.c: too many arguments to function

