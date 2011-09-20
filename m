Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763Ab1ITQTb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 12:19:31 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:42931 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576Ab1ITQT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 12:19:27 -0400
Message-ID: <4E78B85E.3060409@oracle.com>
Date: Tue, 20 Sep 2011 08:59:26 -0700
From: Sunil Mushran <sunil.mushran@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.21) Gecko/20110831 Lightning/1.0b3pre Thunderbird/3.1.13
MIME-Version: 1.0
To: mtk.manpages@gmail.com
CC: Josef Bacik <josef@redhat.com>, linux-man@vger.kernel.org,
        Eric Blake <eblake@redhat.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Man page doc for SEEK_DATA/SEEK_HOLE
References: <CAKgNAkhZSb0UfZz7N+gKRQD0r7gnC_3-VCB_ORio8ojczbCDvQ@mail.gmail.com> <4E778434.6040905@oracle.com> <CAKgNAkgeNBgWEx0-BbSbf83Jtk-AXd+W-YHL-4gTwA6Y_nbR0g@mail.gmail.com>
In-Reply-To: <CAKgNAkgeNBgWEx0-BbSbf83Jtk-AXd+W-YHL-4gTwA6Y_nbR0g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090204.4E78BD0C.0047,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2011 10:32 PM, Michael Kerrisk wrote:
> Hi Sunil,
>
> On Mon, Sep 19, 2011 at 8:04 PM, Sunil Mushran<sunil.mushran@oracle.com>  wrote:
>> On 09/18/2011 12:07 AM, Michael Kerrisk wrote:
>>> Hello Josef,
>>>
>>> For Linux 3.1, you've added SEEK_HOLE + SEEK_DATA. I've attempted to
>>> document these as below for the lseek.2 man page. Could you please
>>> review?
>>>
>>> Thanks,
>>>
>>> Michael
>>>
>>>
>>> diff --git a/man2/lseek.2 b/man2/lseek.2
>>> index 26943e2..941ea08 100644
>>> --- a/man2/lseek.2
>>> +++ b/man2/lseek.2
>>> @@ -85,6 +85,69 @@ of the file (but this does not change the size of the
>>> file).
>>>   If data is later written at this point, subsequent reads of the data
>>>   in the gap (a "hole") return null bytes (\(aq\\0\(aq) until
>>>   data is actually written into the gap.
>>> +.SS Seeking file data and holes
>>> +Since version 3.1, Linux supports the following additional values for
>>> +.IR whence :
>>> +.TP
>>> +.B SEEK_DATA
>>> +Adjust the file offset to the next region
>>> +in the file greater than or equal to
>>> +.I offset
>> I would recommend dropping the word next as it is confusing considering the
>> offset returned could be the offset passed in.
> I changed "region" to "location", but otherwise left this unchanged. I
> couldn't see a good alternative formulation, and also the next
> sentence of the page makes your point clear.

Fine by me.
