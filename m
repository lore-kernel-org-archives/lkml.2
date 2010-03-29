Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751195Ab0C2N0a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 09:26:30 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:61110 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753Ab0C2N02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 09:26:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=q/+S7cf1/mMUtwmIJ55y0lh4ITHxW/bcpd9hwQT3DtrNkU69eVkBtK2KgMkv0cP+uZ
         SUfaXVovCydvpx6EU2y25Z9Eb14VJF4Zjnn1xDljtXYjUeui8T5LE2ldPpzVneb//aZA
         Sk4PC6MNami1pdxyMoOiGku3asO1r0N/UGCRY=
MIME-Version: 1.0
In-Reply-To: <20100329130526.GA23201@redhat.com>
References: <1269812331-8511-1-git-send-regression-fweisbec@gmail.com>
	 <20100329114046.GB16971@redhat.com>
	 <520f0cf11003290506o629c9ab6n95c94c48ba24acf4@mail.gmail.com>
	 <20100329130526.GA23201@redhat.com>
Date: Mon, 29 Mar 2010 15:26:26 +0200
Message-ID: <520f0cf11003290626q2e74c5d1r1eebb07a75e25dd5@mail.gmail.com>
Subject: Re: [PATCH] ptrace: kill BKL in ptrace syscall
From: John Kacur <jkacur@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Roland McGrath <roland@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       Arnd Bergmann <arnd@arndb.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 29, 2010 at 3:05 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 03/29, John Kacur wrote:
>>
>> So, just to be clear about this particular patch, who is queuing it up
>> to send to Linus? Would that be you Oleg, as a ptrace maintainer?
>
> Cough. I must admit, apart from "urgent" bugfixes the only way I know
> is to send the patch to Andrew.
>
> So I'd suggest to send this patch to akpm. Of course, if you wish I can
> forward it, but doesn't matter.
>
> Oleg.
>

I know that in the past, Thomas was keeping a BKL tree in tip, but not sure if
he is still doing so. It seems that Arnd's tree is at least partially
experimental,
so I wonder if we need to maintain another BKL tree somewhere of fixes
that have no
obvious maintainer, but are ready to send to Linus for inclusion?

For fixes that have obvious maintainers though, I would just rather go through
the normal route.

John
