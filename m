Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752336Ab0KATeG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 15:34:06 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:35631 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156Ab0KATeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 15:34:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=QfA9RZZu2Pq+3/f+uZwNDwWRhwqJqoCSLL2qmK/42Bcws/9wrq0Ys4VEhkdV6Uvk4i
         lTkfCsgvUne7b+F8Al40Di5cIqnjWSkDfGW5mjAlINW8I8Ppb2jm/IK7SpneaJhDlv2q
         mMFN0VquI0881jLKL1cfylzXQqeGIcvM5lqxg=
MIME-Version: 1.0
In-Reply-To: <4CCF13FA.1080609@caviumnetworks.com>
References: <1288636877-7964-1-git-send-email-tdent48227@gmail.com>
	<4CCF0D2B.6070308@caviumnetworks.com>
	<201011020814.35902.manningc2@actrix.gen.nz>
	<4CCF13FA.1080609@caviumnetworks.com>
Date: Mon, 1 Nov 2010 15:34:00 -0400
Message-ID: <AANLkTinNsc88EYzh7h-ox+PU3B7+2bTnR2YRrYrk4Hr5@mail.gmail.com>
Subject: Re: [PATCH 0/29] Staging: Add yaffs2 filesystem
From: Tracey Dent <tdent48227@gmail.com>
To: David Daney <ddaney@caviumnetworks.com>
Cc: Charles Manning <manningc2@actrix.gen.nz>, greg@kroah.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/1/10, David Daney <ddaney@caviumnetworks.com> wrote:
> On 11/01/2010 12:14 PM, Charles Manning wrote:
>> On Tuesday 02 November 2010 07:55:39 David Daney wrote:
>>> On 11/01/2010 11:40 AM, Tracey Dent wrote:
>>>> The patch sets puts the yaffs2 filesystem in the staging directory.
>>>> It is all based on Charles git
>>>> tree(http://github.com/cdhmanning/linux-yaffs-integration/). Everything
>>>> is compile tested and it builds.
>>>>
>>>> This only the inital support and I will be sending more cleanup patches.
>>>>
>>>> Greg can you add the patch set into your staging-next tree.
>>>> Also, It doesn't affect anything other than itself.
>>>>
>>>> Thanks,
>>>>
>>>> Tracey Dent
>>>
>>> I am confused.
>>>
>>> Are you and Charles Manning working together on this?
>>>
>>> Did you write all this code or did Charles?  If it was Charles, why are
>>> there no From: and Signed-off-by headers for him?
>>>
>>> Thanks in advance for enlightening us as to what is going on here,
>>> David Daney
>>
>> We are not working together on this, but I do appreciate the effort in
>> helping
>> bring to a head what people like/dislike.
>>
>> I am trying to keep the kernel yaffs consistent with the yaffs.net yaffs
>> so
>> that it is easier to add changes from yaffs.net.
>>
>
> Great.  Thanks for clearing things up.
>
> I will offer my unsolicited opinion:
>
> Charles has obviously expended great effort on yaffs2.  He has a git
> repository hosting the code, and has expressed a desire to get the code
> fit for merging.  For Tracey Dent to come along and hijack the entire
> effort, would anger me if I were in Charles' place.

I didn't mean to hijack, I was just trying to help. :(

>
> Having used yaffs2 in the past, I would like to see the code in the
> kernel.  Having it come via Charles would seem to make sense.
>

But regardless it shouldn't matter who submitted the patches, as long
as we can get it into mainline.
> David Daney
>

Tracey Dent
