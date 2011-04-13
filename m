Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932664Ab1DMTry (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 15:47:54 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:62597 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932094Ab1DMTrx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 15:47:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=sz9ATBINQcyQa2BvznZVGTpNslqO7lTUw0m6daAI2njuKnib+/RGPllnBkActlcHsp
         oZga23JziJCDKhxccfKryEQDP38J7iLo5VU9LJfN/4+EjPvPYIl0UkwY4KzoYudku8gU
         WNcnRP1CvkXwvhpQcwqTw8CtKDmT7FTlpN1ro=
MIME-Version: 1.0
In-Reply-To: <4DA5F569.9020309@gmail.com>
References: <BANLkTini-g9XVOohKjwpZT-SGozcwx720A@mail.gmail.com>
 <4DA4B6A8.7030804@gmail.com> <BANLkTimsAE1ZAJhsSjnh3LqwsN9x0cLaXg@mail.gmail.com>
 <4DA5DCB8.3040101@gmail.com> <BANLkTineg2XYYOZAU9trrw=+-vH8McN_9w@mail.gmail.com>
 <4DA5F569.9020309@gmail.com>
From: Michal Suchanek <hramrach@centrum.cz>
Date: Wed, 13 Apr 2011 21:47:32 +0200
X-Google-Sender-Auth: AHqv_GGmshG5bP-E6IZDPJCLqi8
Message-ID: <BANLkTi=Z1CQm=u2Q1VCHfr=53n5qTC=7bA@mail.gmail.com>
Subject: Re: Unionmount status?
To: Ric Wheeler <ricwheeler@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>, Ian Kent <ikent@redhat.com>,
        Jeff Moyer <jmoyer@redhat.com>, miklos@szeredi.hu,
        Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 April 2011 21:11, Ric Wheeler <ricwheeler@gmail.com> wrote:
> On 04/13/2011 02:58 PM, Michal Suchanek wrote:
>>
>> On 13 April 2011 19:26, Ric Wheeler<ricwheeler@gmail.com>  wrote:
>>>
>>> On 04/12/2011 05:36 PM, Michal Suchanek wrote:
>>>>
>>>> On 12 April 2011 22:31, Ric Wheeler<ricwheeler@gmail.com>    wrote:
>>>>>
>>>>> On 04/12/2011 11:00 AM, Michal Suchanek wrote:
>>>>>>
>>>>>> Hello,
>>>>>>
>>>>>> as some already know the Unionmount VFS union which has been in
>>>>>> development for some years now is the only True Union (TM) that can be
>>>>>> accepted into the kernel mainline by the VFS maintainers (for reasons
>>>>>> of their own which you can surely find if you search the web or ask
>>>>>> them directly).
>>>>>>
>>>>>> The current UnionMount version that can be found here:
>>>>>>
>>>>>>
>>>>>>
>>>>>>
>>>>>> http://git.kernel.org/?p=linux/kernel/git/val/linux-2.6.git;a=shortlog;h=refs/heads/ext2_works
>>>>>>
>>>>>> works for me as good as aufs does. That is I can build a live CD using
>>>>>> this unioning solution and it boots and runs without any apparent
>>>>>> issues.
>>>>>>
>>>>>> There are probably many possible uses of the union which I did not
>>>>>> test nor did I test long term stability of using the unioned
>>>>>> filesystem. As far as ephemeral live systems go it works fine for me,
>>>>>> though.
>>>>>>
>>>>>> The issue is that while the code is (nearly) finished it is not yet
>>>>>> merged into mainline and as I am not familiar with the details of
>>>>>> ever-changing Linux VFS layer forward-porting this code to current
>>>>>> kernels is somewhat challenging.
>>>>>>
>>>>>> What is the plan with unionmount now?
>>>>>>
>>>>>> What is required  for it to be merged into mainline?
>>>>>>
>>>>>> Thanks
>>>>>>
>>>>>> Michal
>>>>>
>>>>> Hi Michal,
>>>>>
>>>>> People are actively looking to see what union mount (or overlayfs)
>>>>> solution
>>>>> to pursue. Val has shifted her focus away from kernel hacking these
>>>>> days,
>>>>> but did refresh her patch set in the last month or so.
>>>>
>>>> I am not aware of such refreshed patch set, at least it is not
>>>> published in her repo.
>>>>
>>> Val posted the refreshed patches with the title on March 22nd:
>>>
>>> http://lwn.net/Articles/435019/
>>>
>> That article references the same four months old repo which I
>> mentioned at the start of the thread, only a slightly different
>> branch.
>>
>> While it maybe useful for testing unionmount (which I already tried)
>> it is not a patch against current kernel which could be used to build
>> current live images.
>>
>> Thanks
>>
>> Michal
>
> She did post the patch series that same date in March - you can probably
> grab the series from linux-fsdevel, look for this series:
>
> "[PATCH 00/74] Union mounts version something or other"
>
> Al Viro was planning on looking at her refreshed patches (he had reviewed
> them with her in person), but that is not going to happen any time soon so
> getting more eyes and testing would be great!
>

Even gmame can't collect the patches back from the ML, I don't want to try.

However, the discussion suggests that these are exactly the 4 months
old branch ending in a commit with the summary "Temporary commit"
which did not inspire confidence in me so I used the previous (also 4
moths old) branch.

Thanks

Michal
