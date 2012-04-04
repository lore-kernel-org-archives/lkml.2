Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932366Ab2DDQi3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 12:38:29 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:42910 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756928Ab2DDQi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 12:38:27 -0400
Message-ID: <4F7C7907.3090808@gmail.com>
Date: Wed, 04 Apr 2012 09:38:31 -0700
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Ulrich Drepper <drepper@gmail.com>
CC: "H. Peter Anvin" <hpa@zytor.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org,
        viro@zeniv.linux.org.uk, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] nextfd(2)
References: <20120401125741.GA7484@p183.telecom.by> <CAHGf_=pgpRrQA3-YVtS=h-Bjq2LyTFmYtKGxxWgwP0XWexnh2g@mail.gmail.com> <4F7A3CC2.1040200@zytor.com> <CAOPLpQebqKED5G1nti6i=JLZ+A6df2UdA86RVEv1Er7hw7KFpQ@mail.gmail.com>
In-Reply-To: <CAOPLpQebqKED5G1nti6i=JLZ+A6df2UdA86RVEv1Er7hw7KFpQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(4/4/12 4:51 AM), Ulrich Drepper wrote:
> On Mon, Apr 2, 2012 at 19:56, H. Peter Anvin<hpa@zytor.com>  wrote:
>>
>> You can deal with this in one of two ways:
>>
>> 2. Fix your malloc().
>> 1. Use the low level open()/getdents()/close() functions instead of
>>    opendir()/readdir()/closedir().
>
> And if their is concern about using opendir() then we can add
> something to posix_spawn.  And attribute like POSIX_SPAWN_CLOSEALL and
> you then would have to explicitly add dup and open requests for the
> descriptors you want to have open.

As far as I understand, any major open source project don't use posix_spawn().
Please remind, I'm talking about real world issue.

