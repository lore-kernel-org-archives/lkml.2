Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140Ab0KATYo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 15:24:44 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:6657 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613Ab0KATYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 15:24:42 -0400
Message-ID: <4CCF13FA.1080609@caviumnetworks.com>
Date: Mon, 01 Nov 2010 12:24:42 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Charles Manning <manningc2@actrix.gen.nz>
CC: Tracey Dent <tdent48227@gmail.com>, greg@kroah.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/29] Staging: Add yaffs2 filesystem
References: <1288636877-7964-1-git-send-email-tdent48227@gmail.com> <4CCF0D2B.6070308@caviumnetworks.com> <201011020814.35902.manningc2@actrix.gen.nz>
In-Reply-To: <201011020814.35902.manningc2@actrix.gen.nz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Nov 2010 19:25:15.0362 (UTC) FILETIME=[82CF9C20:01CB79FA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2010 12:14 PM, Charles Manning wrote:
> On Tuesday 02 November 2010 07:55:39 David Daney wrote:
>> On 11/01/2010 11:40 AM, Tracey Dent wrote:
>>> The patch sets puts the yaffs2 filesystem in the staging directory.
>>> It is all based on Charles git
>>> tree(http://github.com/cdhmanning/linux-yaffs-integration/). Everything
>>> is compile tested and it builds.
>>>
>>> This only the inital support and I will be sending more cleanup patches.
>>>
>>> Greg can you add the patch set into your staging-next tree.
>>> Also, It doesn't affect anything other than itself.
>>>
>>> Thanks,
>>>
>>> Tracey Dent
>>
>> I am confused.
>>
>> Are you and Charles Manning working together on this?
>>
>> Did you write all this code or did Charles?  If it was Charles, why are
>> there no From: and Signed-off-by headers for him?
>>
>> Thanks in advance for enlightening us as to what is going on here,
>> David Daney
>
> We are not working together on this, but I do appreciate the effort in helping
> bring to a head what people like/dislike.
>
> I am trying to keep the kernel yaffs consistent with the yaffs.net yaffs so
> that it is easier to add changes from yaffs.net.
>

Great.  Thanks for clearing things up.

I will offer my unsolicited opinion:

Charles has obviously expended great effort on yaffs2.  He has a git 
repository hosting the code, and has expressed a desire to get the code 
fit for merging.  For Tracey Dent to come along and hijack the entire 
effort, would anger me if I were in Charles' place.

Having used yaffs2 in the past, I would like to see the code in the 
kernel.  Having it come via Charles would seem to make sense.

David Daney
