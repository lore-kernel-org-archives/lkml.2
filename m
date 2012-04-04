Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932521Ab2DDSpE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 14:45:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50769 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932261Ab2DDSpD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 14:45:03 -0400
Message-ID: <4F7C96A5.4090402@zytor.com>
Date: Wed, 04 Apr 2012 11:44:53 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120316 Thunderbird/11.0
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
CC: Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org,
        viro@zeniv.linux.org.uk, torvalds@linux-foundation.org,
        drepper@gmail.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] nextfd(2)
References: <20120401125741.GA7484@p183.telecom.by> <CAHGf_=pgpRrQA3-YVtS=h-Bjq2LyTFmYtKGxxWgwP0XWexnh2g@mail.gmail.com> <4F7A3CC2.1040200@zytor.com> <4F7C777E.10608@gmail.com>
In-Reply-To: <4F7C777E.10608@gmail.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2012 09:31 AM, KOSAKI Motohiro wrote:
>>
>> OK, so what you're saying here is:
>>
>> Linux doesn't actually have a problem unless:
>> 1. You use the library implementation of opendir/readdir/closedir;
>> 2. You use a nonstandard malloc for the platform which doesn't
>>     correctly set up fork hooks (which I would consider a bug);
> 
> Right. but I'm argue "correctly set up" term because SUS/POSIX don't
> require it.
> It is only a workaround of buggy userland in glibc. SUS still says you
> can't
> use opendir and typical userland people don't want ignore SUS as far as
> possible.

Since you are comparing with a Linux-only system call, any suggestion
that depends on SuS requirements as opposed to Linux requirements is
irrelevant.

> 
> It can. but more ugly. no?
> 

And a new system call isn't?  What planet are you on?

	-hpa
