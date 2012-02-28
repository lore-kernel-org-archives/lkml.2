Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965725Ab2B1WBj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 17:01:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18865 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965021Ab2B1WBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 17:01:38 -0500
Message-ID: <4F4D4EBA.6000309@redhat.com>
Date: Tue, 28 Feb 2012 19:01:30 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-media@vger.kernel.org,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: linux-next: Tree for Feb 23 (media/radio)
References: <20120223143722.d8814b493df968c229da5f20@canb.auug.org.au> <4F46AC34.8090704@xenotime.net> <4F4CF8C6.4030305@xenotime.net>
In-Reply-To: <4F4CF8C6.4030305@xenotime.net>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 28-02-2012 12:54, Randy Dunlap escreveu:
> On 02/23/2012 01:14 PM, Randy Dunlap wrote:
> 
>> On 02/22/2012 07:37 PM, Stephen Rothwell wrote:
>>> Hi all,
>>>
>>> Changes since 20120222:
>>
> 
> 
> ping.
> 
> These build errors still happen in linux-next 20120228.

It is likely due to Hans ISA patch series.

Hans,

Could you please add the proper include file to the ISA radio framework?

Thanks!
Mauro
> 
> 
>>
>> on i386:
>>
>> Looks like several source files need to #include <linux/slab.h>:
>>
>>
>> drivers/media/radio/radio-isa.c:246:3: error: implicit declaration of function 'kfree'
>> drivers/media/radio/radio-aztech.c:72:9: error: implicit declaration of function 'kzalloc'
>> drivers/media/radio/radio-aztech.c:72:22: warning: initialization makes pointer from integer without a cast
>> drivers/media/radio/radio-typhoon.c:76:9: error: implicit declaration of function 'kzalloc'
>> drivers/media/radio/radio-typhoon.c:76:23: warning: initialization makes pointer from integer without a cast
>> drivers/media/radio/radio-terratec.c:57:2: error: implicit declaration of function 'kzalloc'
>> drivers/media/radio/radio-terratec.c:57:2: warning: return makes pointer from integer without a cast
>> drivers/media/radio/radio-aimslab.c:67:9: error: implicit declaration of function 'kzalloc'
>> drivers/media/radio/radio-aimslab.c:67:22: warning: initialization makes pointer from integer without a cast
>> drivers/media/radio/radio-zoltrix.c:80:9: error: implicit declaration of function 'kzalloc'
>> drivers/media/radio/radio-zoltrix.c:80:24: warning: initialization makes pointer from integer without a cast
>> drivers/media/radio/radio-gemtek.c:183:9: error: implicit declaration of function 'kzalloc'
>> drivers/media/radio/radio-gemtek.c:183:22: warning: initialization makes pointer from integer without a cast
>> drivers/media/radio/radio-trust.c:57:9: error: implicit declaration of function 'kzalloc'
>> drivers/media/radio/radio-trust.c:57:21: warning: initialization makes pointer from integer without a cast
>>
> 
> 
> 

