Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213Ab0ERWxt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 18:53:49 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:49705 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423Ab0ERWxq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 18:53:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PnvPVty4Jl39y7dzcZQ1m+n0EEnvxY/2w+nrB6LhsCAHbR60aN+PJK1QdxNPf3dii/
         2IqbU4UcBmaKDhl6QrAGTG1P0dCtMxecjYLvKksNTO+q+3GvxzWS7gTfOGQE6MKv38dR
         YDrKzfF4pneN4Kin/hBLAofkgpp+lFTISrNd4=
MIME-Version: 1.0
In-Reply-To: <20100518145212.GA21448@elte.hu>
References: <20100517212848.GA28536@elte.hu>
	 <alpine.LFD.2.00.1005180729340.4195@i5.linux-foundation.org>
	 <20100518145212.GA21448@elte.hu>
Date: Wed, 19 May 2010 04:23:45 +0530
Message-ID: <AANLkTinjnt-_LnW7Aa75T8S-hM2nffH-EUNnAUUAps-Q@mail.gmail.com>
Subject: Re: [GIT PULL, v2] core/locking changes for v2.6.35
From: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ingo,

On Tue, May 18, 2010 at 8:22 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
>> On Mon, 17 May 2010, Ingo Molnar wrote:
>> >
>> > Tony Breeds (1):
>> >       mutex: Fix optimistic spinning vs. BKL
>>
>> Grr. This has the ugly timeout thing, but what's _really_ ugly about it is
>>
>>       kernel/mutex.c: In function ‘__mutex_lock_common’:
>>       kernel/mutex.c:148: warning: unused variable ‘timeout’
>>
>> Nasty. It happens when spinning is disabled due to
>> lockdep or whatever debugging that kills it.
>
> Sorry about that.
>

Sweet, you do not forgive others, but you expect that others forgive you.

--
Jaswinder Singh.
