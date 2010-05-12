Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186Ab0ELRKE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 13:10:04 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:50959 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121Ab0ELRKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 13:10:02 -0400
Message-ID: <4BEAE0C9.9000706@oracle.com>
Date: Wed, 12 May 2010 10:09:29 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: mmotm 2010-05-11-18-20 uploaded (aio build)
References: <201005120149.o4C1n7P4002637@imap1.linux-foundation.org>	<20100512095043.cc5d22b3.randy.dunlap@oracle.com> <x49bpclrqtt.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49bpclrqtt.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090208.4BEAE0D9.01F3:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/10 10:07, Jeff Moyer wrote:
> Randy Dunlap <randy.dunlap@oracle.com> writes:
> 
>> On Tue, 11 May 2010 18:21:22 -0700 akpm@linux-foundation.org wrote:
>>
>>> The mm-of-the-moment snapshot 2010-05-11-18-20 has been uploaded to
>>>
>>>    http://userweb.kernel.org/~akpm/mmotm/
>>>
>>> and will soon be available at
>>>
>>>    git://zen-kernel.org/kernel/mmotm.git
>>
>>
>> aio-fix-the-compat-vectored-operations.patch:
>>
>> (1) when CONFIG_AIO is not enabled, there are hundreds of this warning:
>>
>> include/linux/aio.h:226: warning: no return statement in function returning non-void
>>
>>
>> (2) when CONFIG_AIO=y, CONFIG_IA32_EMULATION=n, CONFIG_COMPAT=n:
>>
>> fs/aio.c:1393: error: implicit declaration of function 'compat_rw_copy_check_uvector'
> 
> Sorry about that.  I'll fix it up, but probably can't get to it until
> Monday.  Hopefully that's an ok timeframe.

Sure, not a problem IMO.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
