Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124Ab1DLN7z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 09:59:55 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51691 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755856Ab1DLN7y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 09:59:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PDCmYrsLjBuoYOl5uV8QmDLy5YsQorWEX0stN1ZyqS9hLqZ5HrL3sqw3ziLPL/UYGb
         9fUQ5ZcO4asQSYD4W0beWpHlYdEf4RX+fB7oCoUSmwVn6CF7ohEBqEgDvNxsIQfeM20p
         oajt9CdKMCTzvq8gZ2TKRtJtZWBjnrEtxvECY=
MIME-Version: 1.0
In-Reply-To: <4DA44E8B.9040101@fusionio.com>
References: <BANLkTimAY2YTFE1_uFJg=XVtV_ww2jdJrw@mail.gmail.com>
	<BANLkTimAvqT0MxPWvQH6ga698TYhCXF3CQ@mail.gmail.com>
	<4DA44E8B.9040101@fusionio.com>
Date: Tue, 12 Apr 2011 15:59:53 +0200
Message-ID: <BANLkTimJDxZ4qBRNnwE9L=3bfEU0WOhd6A@mail.gmail.com>
Subject: Re: regression - slow git rebase performance with 2.6.39-rcX kernel
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Pekka Enberg <penberg@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Theodore Tso <tytso@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/12 Jens Axboe <jaxboe@fusionio.com>:
> On 2011-04-12 14:51, Pekka Enberg wrote:
>> Hi,
>>
>> [ Fixed your empty CC list. ]
>>
>> On Tue, Apr 12, 2011 at 3:45 PM, Zdenek Kabelac
>> <zdenek.kabelac@gmail.com> wrote:
>>> I'm noticing quite slower speed of my git rebase commands on my git
>>> tree compared with 2.6.38 kernel.
>>> I've  T61 with SSD disc drive, ext4 fs, and by default deadline disk
>>> io scheduler
>>> The counter showing the number of 'rebased' patches on top of master
>>> is going much slower.
>>> When I boot 2.6.38 kernel it's much faster.
>>>
>>> Is it a known problem - or do I need to make a bisect ?
>>
>> No, I don't think it's a known problem. Git bisect would be helpful,
>> obviously.
>
> Definitely, interesting. Bisect would help. I'll try a similar workload
> here and see if I see any differences. How big is your rebase, and what
> are the runtimes (approximately) on .38 vs .39-rc?
>

I've made just quick build with the small kernel without debug options
enable - and the time is then equal with 2.6.38. So the difference is
probably somewhere in debug build  -  I assume some debug option
slowed down between 2.6.38 - 2.6.39 significantly.

Zdenek
