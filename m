Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590Ab1ATMlZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 07:41:25 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:35372 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755560Ab1ATMlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 07:41:24 -0500
Message-ID: <4D382DFA.8050806@oracle.com>
Date: Thu, 20 Jan 2011 18:13:38 +0530
From: Gurudas Pai <gurudas.pai@oracle.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: hughd@google.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] kernel BUG at mm/truncate.c:479! on 2.6.37-rc8
References: <4D1AD935.1020504@oracle.com> <alpine.LSU.2.00.1012291137080.6381@sister.anvils> <4D1C2E86.9000004@oracle.com> <4D37DAD7.3050100@oracle.com> <E1Pfsfh-0007iL-6X@pomaz-ex.szeredi.hu>
In-Reply-To: <E1Pfsfh-0007iL-6X@pomaz-ex.szeredi.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi wrote:
> On Thu, 20 Jan 2011, Gurudas Pai wrote:
>> Hi Hugh,
>>
>> Gurudas Pai wrote:
>>>>> With 2.6.37-rc8 , run a fio test over nfs, with following jobfile, 
>>>>> and we
>>>>> hit kernel bug.
>>>> Have you tried the same test on earlier releases?
>>>> I think the bug is old, yet only recently reported.
>>> I tried with 2.6.36.2 , even there it is panicing.
>>>
>>>
>>>> This NFS-triggered kernel BUG at mm/truncate.c:479 sounds very like
>>>> the FUSE-triggered kernel BUG at mm/truncate.c:475 on 2.6.36.1 for
>>>> which Miklos posted a patch on 14 December.  Please give his patch
>>>> (below) a try and let us know if it fixes the issue for you - thanks.
>>> Issue fixed with the patch, Thanks :)
>> Is this patch included in mainline ?
> 
> Apparently not.  I'll update the patch and send it to Andrew shorty.

Thanks Miklos. Please let me know if further testing is required, happy 
to test.

Thanks,
-Guru
