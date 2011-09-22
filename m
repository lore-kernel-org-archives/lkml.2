Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317Ab1IVLpy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 07:45:54 -0400
Received: from lucidpixels.com ([72.73.18.11]:43986 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752758Ab1IVLpx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 07:45:53 -0400
Date: Thu, 22 Sep 2011 07:45:52 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: How to pull 3.1-rc7 since *.kernel.org is still down?
In-Reply-To: <CAHp75Vc8DPvOL210Qws_eiA+SRvf3T2Dr-v6u+yGA_HXXEt48w@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1109220744500.7122@p34.internal.lan>
References: <alpine.DEB.2.02.1109220439390.7122@p34.internal.lan> <CAHp75Vc8DPvOL210Qws_eiA+SRvf3T2Dr-v6u+yGA_HXXEt48w@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 22 Sep 2011, Andy Shevchenko wrote:

> On Thu, Sep 22, 2011 at 11:40 AM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>
>> As kernel.org is still off-line, how does one pull 3.1-rc7 down to test?
>> What is the git/mirror commands and against which host?
>>
>> (normally I just pull the patch from kernel.org)
>
> Linus published it on github.
> github  git://github.com/torvalds/linux.git (fetch)

Command:
$ git clone git://github.com/torvalds/linux.git

Thanks, worked, no problems, now to test out 3.1-rc7 :)

Justin.

