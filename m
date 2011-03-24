Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757132Ab1CXTEN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 15:04:13 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:59760 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757038Ab1CXTEM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 15:04:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=TdnHC8hJFGHc5eysK9nE6E12DKSQtvyTrdlXjBlZaR7csD59+nysmuMyFujpOfQWHy
         jbab5Nx0bC16OgmyoYd+ZfY4rSdgeCYzFZWmF18+26EkVoIZ7cFmJ6b3hcWDC06MtkU8
         AF+DRVJEr1LwN5p8PHuQDHrj/jQqQi0zcricM=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1103241401090.5576@router.home>
References: <alpine.DEB.2.00.1103221635400.4521@tiger>
	<20110324142146.GA11682@elte.hu>
	<alpine.DEB.2.00.1103240940570.32226@router.home>
	<AANLkTikb8rtSX5hQG6MQF4quymFUuh5Tw97TcpB0YfwS@mail.gmail.com>
	<20110324172653.GA28507@elte.hu>
	<alpine.DEB.2.00.1103241242450.32226@router.home>
	<AANLkTimMcP-GikCCndQppNBsS7y=4beesZ4PaD6yh5y5@mail.gmail.com>
	<alpine.DEB.2.00.1103241300420.32226@router.home>
	<AANLkTi=KZQd-GrXaq4472V3XnEGYqnCheYcgrdPFE0LJ@mail.gmail.com>
	<alpine.DEB.2.00.1103241312280.32226@router.home>
	<1300990853.3747.189.camel@edumazet-laptop>
	<alpine.DEB.2.00.1103241346060.32226@router.home>
	<1300992708.3747.211.camel@edumazet-laptop>
	<alpine.DEB.2.00.1103241401090.5576@router.home>
Date: Thu, 24 Mar 2011 21:04:11 +0200
X-Google-Sender-Auth: w_b_AmJNC0S7C4Tgde1dNr5clSk
Message-ID: <AANLkTimU4ccaUUyKfgoUCkgxORkWDhqAQAkX-=SVwq8J@mail.gmail.com>
Subject: Re: [GIT PULL] SLAB changes for v2.6.39-rc1
From: Pekka Enberg <penberg@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        tj@kernel.org, npiggin@kernel.dk, rientjes@google.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 9:02 PM, Christoph Lameter <cl@linux.com> wrote:
> On Thu, 24 Mar 2011, Eric Dumazet wrote:
>
>> Le jeudi 24 mars 2011 à 13:47 -0500, Christoph Lameter a écrit :
>>
>> > Hmmm.. Could be. KVM would not really disable interrupts so this may
>> > explain that the test case works here.
>> >
>> > Simple fix would be to do a load before the cli I guess.
>> >
>>
>> Hmm...
>>
>> If we have a preemption and migration right after this load...
>
> Cannot be the issue here since init_kmem_cache_cpus already
> touches the per cpu data. At least if CONFIG_PREEMPT is on.
> Is it on?

It's not.
