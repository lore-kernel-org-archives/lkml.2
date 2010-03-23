Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559Ab0CWN7u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 09:59:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17143 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753539Ab0CWN7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 09:59:48 -0400
Message-ID: <4BA8C952.2000104@redhat.com>
Date: Tue, 23 Mar 2010 09:59:46 -0400
From: William Cohen <wcohen@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.3
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add DocBook documentation for the block tracepoints.
References: <1267811199-29812-1-git-send-email-wcohen@redhat.com> <4B932672.3010309@xenotime.net> <4B952AC1.1030601@redhat.com> <4B95A1CD.2050401@xenotime.net> <4BA7B352.90301@redhat.com> <4BA7B45D.2050102@xenotime.net> <20100323064704.GR5768@kernel.dk>
In-Reply-To: <20100323064704.GR5768@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23/2010 02:47 AM, Jens Axboe wrote:
> On Mon, Mar 22 2010, Randy Dunlap wrote:
>> On 03/22/10 11:13, William Cohen wrote:
>>> On 03/08/2010 08:18 PM, Randy Dunlap wrote:
>>>> On 03/08/10 08:50, William Cohen wrote:
>>>>> On 03/06/2010 11:07 PM, Randy Dunlap wrote:
>>>>>> William Cohen wrote:
>>>>>>> This patch adds a simple description of the various block tracepoints
>>>>>>> available in the kernel.
>>>>>>>
>>>>>>> Signed-off-by: William Cohen <wcohen@redhat.com>
>>>>>>
>>>>>> Thanks.  I have just a few nits below then it will be ready IMO.
>>>>>
>>>>> I have gone through the patch and made the changes. Below is the updated patch
>>>>>
>>>>> -Will
>>>>>
>>>>>
>>>>> Signed-off-by: William Cohen <wcohen@redhat.com>
>>>>
>>>> Thanks, looks good.  I'll merge it or get Jens to merge it.
>>>
>>> Hi Randy,
>>>
>>> Which git repository is this going into? I didn't see it in any of the git repositories I looked at.
>>
>> Hi Will,
>>
>> Jens told me that he would merge it.  Jens??
> 
> I did, it's in the for-linus branch waiting for a .34 merge.
> 

Thanks for the pointer. I found the patch on the for-linus branch:

http://git.kernel.org/?p=linux/kernel/git/axboe/linux-2.6-block.git;a=commit;h=881245dcff29df992d8431392a41fb81549129f9


-Will
