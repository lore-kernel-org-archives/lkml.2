Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192Ab0G0L0i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 07:26:38 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:49525 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756049Ab0G0L0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 07:26:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=GzAi7MmeoR+X/D7iWeiQRuGyZ9ekRLHkziMbUDIqxP0jIrgu9shwvacWsFcvsmFqIc
         owNjYu9nGfsfuzdZXpXWsGyfxkjotgD6HFISaN557YTuW/1+6G5MSCyRMNr63YPqe9jt
         PdzxL1p6dzZS4aE4Z7J5yXNR/tdGdK3olfNqA=
MIME-Version: 1.0
In-Reply-To: <20100727200804.2F40.A69D9226@jp.fujitsu.com>
References: <AANLkTikjJ0giM+MpzNu3e0NQN=JLMviPT8UPHdZqGGpz@mail.gmail.com> 
	<AANLkTinT_W4Zfg8xcpKXMpqTAomdVBdHve7VqamdSr4o@mail.gmail.com> 
	<20100727200804.2F40.A69D9226@jp.fujitsu.com>
From: dave b <db.pub.mail@gmail.com>
Date: Tue, 27 Jul 2010 21:26:16 +1000
Message-ID: <AANLkTin47_htYK8eV-6C4QkRK_U__qYeWX16Ly=YK-0w@mail.gmail.com>
Subject: Re: PROBLEM: oom killer and swap weirdness on 2.6.3* kernels
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 July 2010 21:14, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
>> On 27 July 2010 18:09, dave b <db.pub.mail@gmail.com> wrote:
>> > On 27 July 2010 16:09, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
>> >>> > Do you mean the issue will be gone if disabling intel graphics?
>> >>> It may be a general issue or it could just be specific :)
>> >
>> > I will try with the latest ubuntu and report how that goes (that will
>> > be using fairly new xorg etc.) it is likely to be hidden issue just
>> > with the intel graphics driver. However, my concern is that it isn't -
>> > and it is about how shared graphics memory is handled :)
>>
>>
>> Ok my desktop still stalled and no oom killer was invoked when I added
>> swap to a live-cd of 10.04 amd64.
>>
>> *Without* *swap* *on* - the oom killer was invoked - here is a copy of it.
>
> This stack seems similar following bug. can you please try to disable intel graphics
> driver?
>
> https://bugzilla.kernel.org/show_bug.cgi?id=14933

Ok I am not sure how to do that :)
I could revert the patch and see if it 'fixes' this :)
