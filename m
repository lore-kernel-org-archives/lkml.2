Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752321Ab0JRDMn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 23:12:43 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64499 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751054Ab0JRDMn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 23:12:43 -0400
Message-ID: <4CBBBB34.7060702@cn.fujitsu.com>
Date: Mon, 18 Oct 2010 11:12:52 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "Ma, Ling" <ling.ma@intel.com>, Ingo Molnar <mingo@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        "Zhao, Yakui" <yakui.zhao@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 -tip] lib,x86_64: improve the performance of memcpy()
 for unaligned copy
References: <4CAEC81C.1070108@cn.fujitsu.com> <C10D3FB0CD45994C8A51FEC1227CE22F15C916E769@shsmsx502.ccr.corp.intel.com> <4CAEDE0D.2040009@cn.fujitsu.com> <4CB62543.7000605@zytor.com>
In-Reply-To: <4CB62543.7000605@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Oct 2010 14:31:47 -0700, H. Peter Anvin wrote:
> On 10/08/2010 02:02 AM, Miao Xie wrote:
>> On Fri, 8 Oct 2010 15:42:45 +0800, Ma, Ling wrote:
>>> Could you please give us full address for each comparison result,we will do some tests on my machine.
>>> For unaligned cases older cpus will crossing cache line and slow down caused by load and store, but for nhm, no necessary to care about it.
>>> By the way in kernel 64bit mode, our access mode should be around 8byte aligned.
>>
>> Would you need my benchmark tool? I think it is helpful for your test.
>>
>
> If you could post the benchmark tool that would be great.

The following is the URL of the benchmark tool that I have posted.
   http://marc.info/?l=linux-kernel&m=128652854608425&q=p3

Thanks
Miao
