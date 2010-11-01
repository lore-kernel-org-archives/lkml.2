Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462Ab0KAUQv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 16:16:51 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:8147 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265Ab0KAUQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 16:16:50 -0400
Message-ID: <4CCF2031.7070903@caviumnetworks.com>
Date: Mon, 01 Nov 2010 13:16:49 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Tracey Dent <tdent48227@gmail.com>
CC: Charles Manning <manningc2@actrix.gen.nz>, greg@kroah.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/29] Staging: Add yaffs2 filesystem
References: <1288636877-7964-1-git-send-email-tdent48227@gmail.com>	<4CCF0D2B.6070308@caviumnetworks.com>	<201011020814.35902.manningc2@actrix.gen.nz>	<4CCF13FA.1080609@caviumnetworks.com> <AANLkTinNsc88EYzh7h-ox+PU3B7+2bTnR2YRrYrk4Hr5@mail.gmail.com>
In-Reply-To: <AANLkTinNsc88EYzh7h-ox+PU3B7+2bTnR2YRrYrk4Hr5@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Nov 2010 20:17:22.0868 (UTC) FILETIME=[CAF32740:01CB7A01]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2010 12:34 PM, Tracey Dent wrote:
> On 11/1/10, David Daney<ddaney@caviumnetworks.com>  wrote:
>> On 11/01/2010 12:14 PM, Charles Manning wrote:
>>> On Tuesday 02 November 2010 07:55:39 David Daney wrote:
>>>> On 11/01/2010 11:40 AM, Tracey Dent wrote:
>>>>> The patch sets puts the yaffs2 filesystem in the staging directory.
>>>>> It is all based on Charles git
>>>>> tree(http://github.com/cdhmanning/linux-yaffs-integration/). Everything
>>>>> is compile tested and it builds.
>>>>>
>>>>> This only the inital support and I will be sending more cleanup patches.
>>>>>
>>>>> Greg can you add the patch set into your staging-next tree.
>>>>> Also, It doesn't affect anything other than itself.
>>>>>
>>>>> Thanks,
>>>>>
>>>>> Tracey Dent
>>>>
>>>> I am confused.
>>>>
>>>> Are you and Charles Manning working together on this?
>>>>
>>>> Did you write all this code or did Charles?  If it was Charles, why are
>>>> there no From: and Signed-off-by headers for him?
>>>>
>>>> Thanks in advance for enlightening us as to what is going on here,
>>>> David Daney
>>>
>>> We are not working together on this, but I do appreciate the effort in
>>> helping
>>> bring to a head what people like/dislike.
>>>
>>> I am trying to keep the kernel yaffs consistent with the yaffs.net yaffs
>>> so
>>> that it is easier to add changes from yaffs.net.
>>>
>>
>> Great.  Thanks for clearing things up.
>>
>> I will offer my unsolicited opinion:
>>
>> Charles has obviously expended great effort on yaffs2.  He has a git
>> repository hosting the code, and has expressed a desire to get the code
>> fit for merging.  For Tracey Dent to come along and hijack the entire
>> effort, would anger me if I were in Charles' place.
>
> I didn't mean to hijack, I was just trying to help. :(
>
>>
>> Having used yaffs2 in the past, I would like to see the code in the
>> kernel.  Having it come via Charles would seem to make sense.
>>
>
> But regardless it shouldn't matter who submitted the patches, as long
> as we can get it into mainline.

In the very real world we live in, proper attribution of kernel patch 
authorship can make a concrete difference in employment decisions.  And 
even without the monetary considerations, the health of the 'ecosystem' 
in which we operate is damaged if credit is not granted where due.

David Daney
