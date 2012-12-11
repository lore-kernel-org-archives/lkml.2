Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700Ab2LKCfS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 21:35:18 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47812 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752173Ab2LKCfO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 21:35:14 -0500
Message-ID: <50C69BC8.2030702@zytor.com>
Date: Mon, 10 Dec 2012 18:34:48 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Michael Wang <wangyun@linux.vnet.ibm.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: TIP tree's master branch failed to boot up
References: <50C56A13.9040604@linux.vnet.ibm.com> <50C615A3.8090400@zytor.com> <50C698FD.7000503@linux.vnet.ibm.com>
In-Reply-To: <50C698FD.7000503@linux.vnet.ibm.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2012 06:22 PM, Michael Wang wrote:
> On 12/11/2012 01:02 AM, H. Peter Anvin wrote:
>> On 12/09/2012 08:50 PM, Michael Wang wrote:
>>> Hi, Folks
>>>
>>> I'm testing with the latest tip tree's master branch 3.7.0-rc8 and
>>> failed to boot up my server, it's hung at very beginning and I could not
>>> catch any useful log, is there any one else got this problem or I'm the
>>> only one?.
>>>
>>> Regards,
>>> Michael Wang
>>>
>>
>> 32 or 64 bits?
> 
> 64 bits.
> 

Thanks.  We're working on that patchset and have found a bunch of
issues, hopefully we can get them resolved very soon.

	-hpa


