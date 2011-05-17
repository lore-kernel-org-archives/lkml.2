Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859Ab1EQIr5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 04:47:57 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:49840 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790Ab1EQIr4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 04:47:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wS5fQtmXfQWM9hIA0opj1VkhEBzUzYzcc1gYnSDOfOUn9XZ0Hk6lCcDBhgYij4LMS6
         1pUiUd0CRx504lNIw9W7LOtm9RMLPLbToYxYYsGFZay+ZX+zkuYA+1A1J6DB+XrHVrZP
         UMhPQJ61Vs+5HhA5hMc24ch/kjTPXzrZ8EdHA=
MIME-Version: 1.0
In-Reply-To: <4DD23456.6060400@gmail.com>
References: <4DD0F614.2040408@gmail.com>
	<1305540776.2466.4094.camel@twins>
	<20110516103559.GA19837@elte.hu>
	<4DD23456.6060400@gmail.com>
Date: Tue, 17 May 2011 16:47:55 +0800
Message-ID: <BANLkTikrLqmkDpOs4V46RCTd+5-GZhtZDA@mail.gmail.com>
Subject: Re: [PATCH] Documentation: statistics about nested locks
From: Yong Zhang <yong.zhang0@gmail.com>
To: Juri Lelli <juri.lelli@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 17, 2011 at 4:39 PM, Juri Lelli <juri.lelli@gmail.com> wrote:
> Sorry for my mistake with the email client and thanks for the hint!
> May I resend a (I hope) corrected version of this small patch with the revision
> made by Yong?

No problem on my side :)

Thanks,
Yong

>
> On 05/16/2011 12:35 PM, Ingo Molnar wrote:
>>
>> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>>
>>> On Mon, 2011-05-16 at 12:01 +0200, Juri Lelli wrote:
>>>> +The graph below shows the relation between the lock functions and the
>>>> various
>>>> +hooks therein.
>>>
>>> That smells like the patch has whitespace damage..
>>
>> Yeah, Documentation/email-clients.txt might help there.
>>
>> Thanks,
>>
>>       Ingo
>
> Thanks,
>
>        Juri
>



-- 
Only stand for myself
