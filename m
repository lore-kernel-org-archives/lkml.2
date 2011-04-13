Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933223Ab1DMR1H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 13:27:07 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37792 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932664Ab1DMR1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 13:27:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=RJOLgRcNtSsH3nXPO/VDSMo9AoriEI8uuLiOkSGRZQ0vROhhzbI6TKWrTK8utcO9ar
         oVLLHHbnwGHDXWyeDhurPZ+OdyRa2d0zj+nhaM/mXP2iUpx8QbLiLFoUZe3grh4dX5Fo
         d7Z6WNIz91tzAfDjrOWlJ3v7gbnMwafgSLYLs=
Message-ID: <4DA5DCB8.3040101@gmail.com>
Date: Wed, 13 Apr 2011 13:26:16 -0400
From: Ric Wheeler <ricwheeler@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110403 Fedora/3.1.9-6.fc15 Thunderbird/3.1.9
MIME-Version: 1.0
To: Michal Suchanek <hramrach@centrum.cz>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>, Ian Kent <ikent@redhat.com>,
        Jeff Moyer <jmoyer@redhat.com>, miklos@szeredi.hu,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: Unionmount status?
References: <BANLkTini-g9XVOohKjwpZT-SGozcwx720A@mail.gmail.com> <4DA4B6A8.7030804@gmail.com> <BANLkTimsAE1ZAJhsSjnh3LqwsN9x0cLaXg@mail.gmail.com>
In-Reply-To: <BANLkTimsAE1ZAJhsSjnh3LqwsN9x0cLaXg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2011 05:36 PM, Michal Suchanek wrote:
> On 12 April 2011 22:31, Ric Wheeler<ricwheeler@gmail.com>  wrote:
>> On 04/12/2011 11:00 AM, Michal Suchanek wrote:
>>> Hello,
>>>
>>> as some already know the Unionmount VFS union which has been in
>>> development for some years now is the only True Union (TM) that can be
>>> accepted into the kernel mainline by the VFS maintainers (for reasons
>>> of their own which you can surely find if you search the web or ask
>>> them directly).
>>>
>>> The current UnionMount version that can be found here:
>>>
>>>
>>> http://git.kernel.org/?p=linux/kernel/git/val/linux-2.6.git;a=shortlog;h=refs/heads/ext2_works
>>>
>>> works for me as good as aufs does. That is I can build a live CD using
>>> this unioning solution and it boots and runs without any apparent
>>> issues.
>>>
>>> There are probably many possible uses of the union which I did not
>>> test nor did I test long term stability of using the unioned
>>> filesystem. As far as ephemeral live systems go it works fine for me,
>>> though.
>>>
>>> The issue is that while the code is (nearly) finished it is not yet
>>> merged into mainline and as I am not familiar with the details of
>>> ever-changing Linux VFS layer forward-porting this code to current
>>> kernels is somewhat challenging.
>>>
>>> What is the plan with unionmount now?
>>>
>>> What is required  for it to be merged into mainline?
>>>
>>> Thanks
>>>
>>> Michal
>> Hi Michal,
>>
>> People are actively looking to see what union mount (or overlayfs) solution
>> to pursue. Val has shifted her focus away from kernel hacking these days,
>> but did refresh her patch set in the last month or so.
> I am not aware of such refreshed patch set, at least it is not
> published in her repo.
>

Val posted the refreshed patches with the title on March 22nd:

http://lwn.net/Articles/435019/

Ric

>> Miklos has an overlay file system that has also been posted upstream.
> I have no idea about his other overlay filesystem either.
>
>> I think that testing like you did and getting more eyes to look at the code
>> is the next key step for both projects.
>>
> Could you provide more details?
>
> I am not following the Linux fs development closely.
>
> Thanks
>
> Michal

