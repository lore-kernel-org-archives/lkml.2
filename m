Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965181Ab0HFXfS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 19:35:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33038 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762166Ab0HFXfP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 19:35:15 -0400
Message-ID: <4C5C9BC2.8020502@zytor.com>
Date: Fri, 06 Aug 2010 16:33:22 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Simon Horman <horms@verge.net.au>
CC: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        Eric Biederman <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] MAINTAINERS: kexec-tools has moved
References: <20100729041641.GA32220@verge.net.au> <20100806233203.GA10040@verge.net.au>
In-Reply-To: <20100806233203.GA10040@verge.net.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2010 04:32 PM, Simon Horman wrote:
> On Thu, Jul 29, 2010 at 01:16:41PM +0900, Simon Horman wrote:
>> Kexec tools has been moved to http://kernel.org/pub/linux/utils/kernel/kexec/
>> as user-space code shouldn't be in /pub/linux/kernel
>>
>> Signed-off-by: Simon Horman <horms@verge.net.au>
> 
> Eric, ping.
> 
> What is your preferred path for this change to get merged?
> 
>>
>> Index: linux-2.6/MAINTAINERS
>> ===================================================================
>> --- linux-2.6.orig/MAINTAINERS	2010-07-29 13:10:04.000000000 +0900
>> +++ linux-2.6/MAINTAINERS	2010-07-29 13:11:40.000000000 +0900
>> @@ -3334,7 +3334,7 @@ F:	drivers/s390/kvm/
>>  
>>  KEXEC
>>  M:	Eric Biederman <ebiederm@xmission.com>
>> -W:	http://ftp.kernel.org/pub/linux/kernel/people/horms/kexec-tools/
>> +W:	http://kernel.org/pub/linux/utils/kernel/kexec/
>>  L:	kexec@lists.infradead.org
>>  S:	Maintained
>>  F:	include/linux/kexec.h
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/

Eric is on vacation this week, AFAIK.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

