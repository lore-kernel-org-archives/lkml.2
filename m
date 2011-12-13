Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691Ab1LMB4I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 20:56:08 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:35802 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685Ab1LMB4E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 20:56:04 -0500
MIME-Version: 1.0
In-Reply-To: <CAOH1cH=1z2kfs-9t6_uyrBamtMFseBxsVBPq=zfJKVK_edTEyA@mail.gmail.com>
References: <CAOH1cHnymZ1WasD4q+HXbeQb9wBAWmS9f451gEekA0-YjCZtLA@mail.gmail.com>
	<2150.1314882260@redhat.com>
	<CAOH1cHnLfLQzZ8022ivfFkbug=adU1AYZPJOqdTnrqh9vuAAxg@mail.gmail.com>
	<CAOH1cHm-hbC=KZJsT1H5ohVEJVzNvqaKatKVS+s2nKVkAMgX9w@mail.gmail.com>
	<5149.1317036720@redhat.com>
	<CAOH1cHn3QF0QtR7KKN9gk5CiUvLqxsni0yi9bgCmJ8f=N1v27Q@mail.gmail.com>
	<CAOH1cHmTWdCHAprmbH7cfmZCVakdayR3jd031da2X2N3FmjfPw@mail.gmail.com>
	<6324.1317308270@redhat.com>
	<CAOH1cHn0tc-_dFe1PovpKmTE5pnMp40ZXi5TR9+i=ozviTdinA@mail.gmail.com>
	<12748.1317313818@redhat.com>
	<CAOH1cHmFuXn3uZbyZy94-cBGCPDxLsJuskkYRteeBs75iLhssw@mail.gmail.com>
	<CAOH1cHn3_aeVYC73YO43zf5piKOO_=MJwbbVfhW8eAWnDahRrw@mail.gmail.com>
	<18003.1317336244@redhat.com>
	<CAOH1cHmeX56+dZEidR4AAwEkz2kr7-J12vky5G8s0vzfbO39yw@mail.gmail.com>
	<6261.1317385734@redhat.com>
	<CAOH1cHkVjTSBvqvaoWnxTB1V-dOtj1cCT_kMZpJdsyNNeUoBag@mail.gmail.com>
	<8905.1317984176@redhat.com>
	<CAOH1cHkFitTHBkHzg+m7cZycOZTgWW8hF0g0=+pX6bPNVZNTxw@mail.gmail.com>
	<17609.1318584129@redhat.com>
	<CAOH1cHkrtzr4o=ygqrMnUfDhwC=U+QJOtuqS+vfQyeXP_TvjaQ@mail.gmail.com>
	<19081.1319027106@redhat.com>
	<CAOH1cH=smX1tWLB6PwaRfcrOu5YErF3TGUDoRnLZGmxvGH9rAA@mail.gmail.com>
	<29711.1319101384@redhat.com>
	<CAOH1cH=VvOjcE8FAPshytZwmhrwfhS1kcq=oV_btaPON7sWmfQ@mail.gmail.com>
	<28872.1319151902@redhat.com>
	<CAOH1cHkhBTcvsj2NzUKYt-wnbpgqxJkPn_aYombnSTkLV3=WoA@mail.gmail.com>
	<15259.1319185001@redhat.com>
	<CAOH1cH=1z2kfs-9t6_uyrBamtMFseBxsVBPq=zfJKVK_edTEyA@mail.gmail.com>
Date: Mon, 12 Dec 2011 17:56:03 -0800
Message-ID: <CAOH1cHkkKL=LqqaHkmzG6DLckOfVj6vnJnF3BBMqWeXmHxpkSQ@mail.gmail.com>
Subject: Re: [Linux-cachefs] 3.0.3 64-bit Crash running fscache/cachefilesd
From: Mark Moseley <moseleymark@gmail.com>
Cc: Linux filesystem caching discussion list 
	<linux-cachefs@redhat.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 21, 2011 at 11:09 AM, Mark Moseley <moseleymark@gmail.com> wrote:
> On Fri, Oct 21, 2011 at 1:16 AM, David Howells <dhowells@redhat.com> wrote:
>> Mark Moseley <moseleymark@gmail.com> wrote:
>>
>>> >> [67666.389761] kernel BUG at fs/fscache/operation.c:426!
>>> >
>>> > Can you have a look what's on line 426 for you, please?  It's a blank line
>>> > in my kernel.  I think I've managed to rearrange my patches to muck the
>>> > ordering up.
>>>
>>> Here's line 426 with some context:
>>
>> Ah...  It's the same one you've seen before - and now the debugging patch I
>> gave you has yielded a bit more context.
>>
>> David
>>
>
> Ok, got another of the "[33353.585702] kernel BUG at
> fs/fscache/operation.c:426!" variety. I've attached a dump of fscache
> stats from basically the entire uptime of the box, minus the first
> couple minutes, right till it went down.

Anything I should be trying/testing on 3.1.5 or 3.2-rc?
