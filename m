Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693Ab0CSOSR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 10:18:17 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:55154 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705Ab0CSOSQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 10:18:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:mime-version:content-type:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to:x-mailer;
        b=msYX/hUNO6TmvWE8VGVN9T6ABFazoEAS2+iIXLgtgbaKWonNwNHeVkC7h733Ll2xc4
         L9ZsoNs5HZ14ykWx2qL+XIuaTXvOLc2+QpmkPEw7GMkC1qjaXPteBSmbwzlAKGn+RbcL
         ALFvVZZ3IUfz6iUbqM7ytAt2m5bySRwWhksik=
Subject: Re: Balance taking a lot longer than before
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=windows-1252
From: Mark Rada <markrada26@gmail.com>
In-Reply-To: <3d0408631003190032s663624c1o528674f8010309f2@mail.gmail.com>
Date: Fri, 19 Mar 2010 10:18:12 -0400
Cc: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <C514E3D1-A4EB-4460-9994-EBD29CCC6817@gmail.com>
References: <77201DCC-CC67-4B00-8FFE-AAB17A5D18DA@mailservices.uwaterloo.ca> <3d0408631003182019i1509d363j98f94661679ea30b@mail.gmail.com> <E9D4D14F-3CAA-487B-8651-97C43CF418B6@mailservices.uwaterloo.ca> <3d0408631003190032s663624c1o528674f8010309f2@mail.gmail.com>
To: "Yan, Zheng" <yanzheng@21cn.com>
X-Mailer: Apple Mail (2.1077)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't have any files bigger than 5GB, and I'm using less than a quarter of my total disk space but I already have a lot of fragmentation?

Defragmenting won't help, will it? Is there anything I can do other than deleting the files?

—
Mark Rada
markrada26@gmail.com


On 2010-03-19, at 3:32 AM, Yan, Zheng wrote:

> The loop is caused by fragmentaion of free space. Balance code is trying to
> relocate a large file extent, but it can't find a free space that is
> large enough.
> 
> On Fri, Mar 19, 2010 at 11:28 AM, Mark Rada <marada@uwaterloo.ca> wrote:
>> Hmm, there seems to be a very very long list of "btrfs: found 1 extents" messages and nothing else in between them.
>> 
>> Why would deleting large files help? I don't want to delete files on my server unless I have no other option.
>> 
>> —
>> Mark Rada
>> marada@uwaterloo.ca
>> 
>> 
>> On 2010-03-18, at 11:19 PM, Yan, Zheng wrote:
>> 
>>> On Fri, Mar 19, 2010 at 9:44 AM, Mark Rada <marada@uwaterloo.ca> wrote:
>>>> Hi devs,
>>>> 
>>>> I've been using btrfs on my file server since 2.6.32 and after upgrading to .33 I noticed that rebalancing took way longer than before.
>>>> 
>>>> I have a 5 disk array used for a btrfs md setup, different hard drive sizes, brands, and interfaces.
>>>> 
>>>> The last time I rebalanced I was using about 800GB of space on the 4.6TB array, and I started before I went to sleep and it was done when I woke up.
>>>> 
>>>> I'm in the middle of a rebalance right now, currently using 950GB, and it has been a full day and the rebalancing is not done yet. Is this an expected change? Is there any way to tell how much longer it will take? Do you need to know more info about the setup?
>>>> 
>>> 
>>> I guess it enters infinite loops. you can check it by checking if
>>> there are a lots of
>>> repeats messages in the kernel log.  If it is true, you can try
>>> deleting some large
>>> files in that FS.
>> 

