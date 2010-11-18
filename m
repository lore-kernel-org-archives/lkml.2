Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760723Ab0KRV7U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 16:59:20 -0500
Received: from bluebox.CS.Princeton.EDU ([128.112.136.38]:39300 "EHLO
	bluebox.CS.Princeton.EDU" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963Ab0KRV7T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 16:59:19 -0500
Subject: Re: [stable] Boot failure with 2.6.27.46 on Xeon E5620 (Westmere EP)
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=utf-8
From: =?utf-8?Q?=22S=2E=C3=87a=C4=9Flar_Onur=22?= 
	<caglar@CS.Princeton.EDU>
In-Reply-To: <20101118215429.GA29243@kroah.com>
Date: Thu, 18 Nov 2010 16:59:12 -0500
Cc: Youquan Song <youquan.song@linux.intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        "stable@kernel.org" <stable@kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Song, Youquan" <youquan.song@intel.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <42E89D5B-D2D6-42E5-A218-B538968FF6E5@CS.Princeton.EDU>
References: <000954C6-B4AC-4FD8-BA3B-C3B199C7607F@CS.Princeton.EDU> <20100525155307.GA7453@kroah.com> <620C3556-2708-4704-90F3-37DDEF1A404E@CS.Princeton.EDU> <20100525205123.GA14993@kroah.com> <1274833451.2892.574.camel@sbs-t61.sc.intel.com> <DD6ACA75-527D-406D-971B-64F042E0ED26@CS.Princeton.EDU> <20100526132357.GA26728@youquan-linux.bj.intel.com> <E934EC71-FD1D-4750-818F-DDEBA2F68B4D@CS.Princeton.EDU> <20101118215429.GA29243@kroah.com>
To: Greg KH <greg@kroah.com>
X-Mailer: Apple Mail (2.1082)
X-Proofpoint-Virus-Version: vendor=nai engine=5400 definitions=6171 signatures=648885
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Nov 18, 2010, at 4:54 PM, Greg KH wrote:

> On Thu, Nov 18, 2010 at 04:24:40PM -0500, "S.Çağlar Onur" wrote:
>> Hi Youquan & Greg,
>> 
>> 
>> On May 26, 2010, at 9:23 AM, Youquan Song wrote:
>> 
>>>>> I can't think of any known issues in 2.6.27 that can lead to this kind
>>>>> of boot failure on WSM-EP. Caglar, It will be nice if you can do git
>>>>> bisect between working and non-working kernels.
>>>> 
>>>> Sure, I'll try to boot those with plain 2.6.27 to see but please note that it's going to be little time consuming. For each one I have to create a custom boot image for them to download and test (a.k.a. don't expect to hear from me soon :))
>>> 
>>> Hi Caglar,
>>> 
>>> What's the microcode version? Get by "dmesg | grep microcode" if you
>>> success boot other version of kernel.
>>> Can you try to disable C-state(C6) in BIOS before your boot 2.6.27?
>> 
>> First of all I'm really sorry that it took really long time to reply this mail as I was waiting Dell to send a loaner machine to us. This morning I've got the hardware and following patch solved the boot problem that I was observing, Greg could you consider adding that to 2.6.27-stable tree?
>> 
>> commit a0bf284bfedd6dc95bbee7ebf5ccf3b5f753a008
> 
> No problem, now queued up.

Umh please drop that patch for now, seems like I mixed my kernel configs and compiled/tested a 64 bit one (by the way 64bit kernel boots fine) but 32bit one still fails with the same error. I'll try to bisect...

> thanks,
> 
> greg k-h


Best,
--
S.Çağlar Onur <caglar@cs.princeton.edu>

