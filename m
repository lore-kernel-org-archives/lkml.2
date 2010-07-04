Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757933Ab0GDTAn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jul 2010 15:00:43 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:36848 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757561Ab0GDTAm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jul 2010 15:00:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :content-type:content-transfer-encoding;
        b=o8GiVa5ZatT4e75veREUpYno7twgtsOj+AD17Wd/rXCYn0mmzNVuRuh5JwpwHyI77g
         nfNS7uKZ2aMTsBWgk9lbyMTL6UNmMxvz3q1UHyiIVM/IkKqcSqkdqezN9lYn6V0f/ZDj
         wjNmQTo6X8JnlE4UMb6tWCfKjO9kPL8aemVRA=
MIME-Version: 1.0
In-Reply-To: <AANLkTikVrqXlSEALYzKMZtQZY9U6IUtr6nmUwGwbyG6T@mail.gmail.com>
References: <AANLkTil7mInflmvrvVQmOx7xrNVFAY7GtqQiGobHMTT2@mail.gmail.com> 
	<20100621085140.19dda646.randy.dunlap@oracle.com> <AANLkTinQclZGMIcn2VgTH6yd-hUJ_L7Ku7UpuVVBapIG@mail.gmail.com> 
	<4C1FC3EE.8040003@oracle.com> <AANLkTil6E0sA-x9AtIyAU6LGzIi42iyhjITkfVZ2Kxri@mail.gmail.com> 
	<AANLkTikVrqXlSEALYzKMZtQZY9U6IUtr6nmUwGwbyG6T@mail.gmail.com>
From: Weedy <weedy2887@gmail.com>
Date: Sun, 4 Jul 2010 15:00:21 -0400
Message-ID: <AANLkTim6WCAnskN6uT-I-g4elKUg2RBdxHwWKUauaiDD@mail.gmail.com>
Subject: Re: Entropy poolsize
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 22, 2010 at 7:21 PM, Weedy <weedy2887@gmail.com> wrote:
> Man I need to remember to hit reply-to-all
>
> On Mon, Jun 21, 2010 at 3:56 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>> On 06/21/10 12:48, Weedy wrote:
>>> On Mon, Jun 21, 2010 at 11:51 AM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>>>> On Mon, 21 Jun 2010 09:58:16 -0400 Weedy wrote:
>>>>
>>>>> I know grsecurity has a option for this but I don't want to patch my
>>>>> kernel with it at this time. I have been poking around random.c but I
>>>>> can't seem to figure out where .poolsize is assigned it's value and
>>>>> how to increase it.
>>>>>
>>>>> If someone could point it out that would be nice.
>>>>>
>>>>> Thank you for your time.
>>>>> --
>>>>
>>>> Do you mean this one in drivers/char/random.c or something else?
>>>>
>>>> static int sysctl_poolsize = INPUT_POOL_WORDS * 32;
>>>>
>>>> It's a sysctl, so it is tunable.
>>> It's locked, some kind of security risk many kernels ago. I'll try
>>> changing that but I thought I tried it once before.
>>
>> Ah, it's mode is 0444 (read-only).  Sorry I missed that piece.
>> Sure, you could change the mode for your own use (rebuild the kernel).
>
>  # cat /proc/sys/kernel/random/poolsize
> 16384
> cat /proc/sys/kernel/random/entropy_avail
> 4096
>
> I guess there is more to it.
>

Bump
