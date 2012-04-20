Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755759Ab2DTVuy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 17:50:54 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:35618 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755721Ab2DTVuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 17:50:50 -0400
MIME-Version: 1.0
In-Reply-To: <CAE_yGnAGPGsOMPsr8bWhTx8wzE6F0XYB4D89bQB=fGiTLW9LkA@mail.gmail.com>
References: <CAE_yGnAWsWQHCSCLA-LCuugOGTf5L4v2NcQatar4Vv421TNQcw@mail.gmail.com>
	<CAE_yGnDYkoJYVus-iPinSnqTj1CDfaf-oScPjZ2ibDaeeWF0oQ@mail.gmail.com>
	<CAE9FiQW5LwRdM2NRUQZjBkyg023gwXa6r10Ym2bo0L1vk74yBg@mail.gmail.com>
	<CAE_yGnAJ5pEZDXDp1uFaUqZa758+HZbcbcLCgEQh4YYnFBDHxw@mail.gmail.com>
	<CAE9FiQU2JkJPhw4QA0B8+XQDM93LUJ-tcYDcJaXBvHsrt9KRpQ@mail.gmail.com>
	<CAE_yGnAGPGsOMPsr8bWhTx8wzE6F0XYB4D89bQB=fGiTLW9LkA@mail.gmail.com>
Date: Fri, 20 Apr 2012 14:50:50 -0700
X-Google-Sender-Auth: THFOVZEnC0WEM57eI-sQG2fvCVc
Message-ID: <CAE9FiQVUbX5+8sp3jMd1ehmdJ9Qs23t=WPV-PsYnOPvpow6jDg@mail.gmail.com>
Subject: Re: can't boot my laptop with kernel-3.3.*
From: Yinghai Lu <yinghai@kernel.org>
To: Petru Ciobanu <petrea.email@gmail.com>, Tejun Heo <tj@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: "the arch/x86 maintainers" <x86@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2012 at 8:26 PM, Petru Ciobanu <petrea.email@gmail.com> wrote:
> On 17 April 2012 03:34, Yinghai Lu <yinghai@kernel.org> wrote:
>> On Mon, Apr 16, 2012 at 5:41 PM, Scant Light <scantlight@gmail.com> wrote:
>>> 9. http://www.pasteall.org/pic/30333
>>
>> mpc size if 0, please apply attached patch.
>>
>> Thanks
>>
>> Yinghai
>
> thank you very much this patch works fine for me
> I patched the the last stable version 3.3.2 and I was able to boot the
> system successfully
>
> ok... this works for me, but how about others? how about future?
> will this be in the main tracker???

tj's patch fixes the problem

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=patch;h=b3dc627cabb33fc95f93da78457770c1b2a364d2

Yinghai
