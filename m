Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932239Ab2BYE2t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 23:28:49 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:34302 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888Ab2BYE2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 23:28:48 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of jidong.xiao@gmail.com designates 10.181.13.113 as permitted sender) smtp.mail=jidong.xiao@gmail.com; dkim=pass header.i=jidong.xiao@gmail.com
MIME-Version: 1.0
In-Reply-To: <4F48488D.30501@cs.stonybrook.edu>
References: <CAG4AFWb0iG_t+Ps2isC_DF=f3WfVKyL+H-=ybKCtRP=ZmAAUUA@mail.gmail.com>
	<CAG4AFWZD8LeFkidnESCMfYFVFbjekAMJ_OZCTc2NRKJsvN3Qjw@mail.gmail.com>
	<20120224153811.GA16535@kroah.com>
	<CAG4AFWaDxK2r9W7eehAnWHxD92C_fjpL1OQnENuZFjOjXDOYmA@mail.gmail.com>
	<20120224165448.GA8751@kroah.com>
	<CAG4AFWY1a5SGA4AF9hpFrY6VE60OZUFtWmuVH92Ak_KZWs9Xtw@mail.gmail.com>
	<20120224171344.GA9485@kroah.com>
	<4F48488D.30501@cs.stonybrook.edu>
Date: Fri, 24 Feb 2012 23:28:46 -0500
Message-ID: <CAG4AFWYxc8FP5yCoEekOnD6nNNqF0X8+VVgXF8zoksTd9RT_Ow@mail.gmail.com>
Subject: Re: Can we move device drivers into user-space?
From: Jidong Xiao <jidong.xiao@gmail.com>
To: Richard Yao <ryao@cs.stonybrook.edu>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you everyone! I opened this thread mainly because I was
wondering whether it makes sense to move device drivers into user
space. I had no clear idea, but I learnt a lot from the whole
discussion between everyone, and I think I am not the only one who
benefits from this discussion.

Regards
Jidong

On Fri, Feb 24, 2012 at 9:33 PM, Richard Yao <ryao@cs.stonybrook.edu> wrote:
>
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> On 02/24/12 12:13, Greg KH wrote:
>> On Fri, Feb 24, 2012 at 12:06:54PM -0500, Jidong Xiao wrote:
>>> On Fri, Feb 24, 2012 at 11:54 AM, Greg KH <gregkh@linuxfoundation.org>
> wrote:
>>>>> As to "Linux isn't a microkernel", even though the debate between
>>>>> Linux and microkernel have never stopped,
>>>>
>>>> Um, who is having such a debate? We aren't, so I don't think the debate
>>>> has ever started.
>>>>
>>>
>>> Here is the classic debate between Andrew S. Tanenbaum and Linus Torvalds:
>>> http://en.wikipedia.org/wiki/Tanenbaum%E2%80%93Torvalds_debate
>>
>> That was 20 years ago, to assume that anyone rational was still having
>> that debate today is insane.
> Jidong Xiao was correct in saying that there was a debate. It continues
> much like the Korean war does today.
>
> With that said, I suggest that Jidong Xiao switch to MINIX, GNU or his
> own OS based on one of the L4 kernels (SEL4 maybe?).
>
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v2.0.18 (GNU/Linux)
> Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/
>
> iQIcBAEBAgAGBQJPSEiMAAoJELFAT5FmjZuE2fgP/jSLP8a1bloTJAuQhZScXaWS
> 7A9GOYKbtGE6WFaYvzzTNuEON+jK9hQqFAaVpW/GvIJLaQC5agdTzawVi1It/nIk
> 281FXUrFdZiQtEOArwb3sSxLcUgcPeEWaEG798wqM2Vc2LDAgKEaNh01RasH4di1
> v78NRXxCsOfPtszlFbA6u3g/+sjNK2KXKjCPKayN8uzpihvIal+JQx8iunen/TbT
> 3kENQiT6mA1oP/r3/z19ayL0piKpm4YKZI4UwtGWT0QzwpPD69sVrcCS1ddF58O6
> CVl+vsQl/8ptUnLZ115XujXas2y1CioUfkTiKezkGpz/roJoquKwUejamyBc+JHa
> 0Ph5cJBNg/tfiOcQDeM1GYsolfFVBy5Wvn4uh5R24bBi1nLl/YeAe/0eHY43cdoT
> mbusYNbBHYr9Bx6B+1Ehy0c+/hd5949kQqWLchi8INYsRUakXqnYQNEt3Jznkpr8
> sj4Ga9iayEa3OnwLolLDvBmgLFAF4ZUDBiIFsV6QMrGosvm2DC3Cmk/+ZBwOhZkw
> lmLor34YJdVQ/0GivwxoGX12HlMQB7IBQiAnQUX5z+a9BOQTcNf4muXM/rs5cDk1
> jbztbT9BbTKQVKeQMkZLewct+qEfBHuRA5KimoKL+jxmfZw5UqjBRhtR+U4T+C6A
> WTJMtPUD4Z08trnWHxRU
> =H2R7
> -----END PGP SIGNATURE-----
>
