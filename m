Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751769Ab0JEOgp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 10:36:45 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:57052 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658Ab0JEOgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 10:36:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=KWOvlJCCTSTGuQ3iI4tL9Nwzh/likmiYFg5YcrSVjLnAs4Tqegmn4D9g2kEO2ORHH5
         ZKQQnwdMvkra6IcaJNqbcbmQYK9aVh6x6RajqbxVxQLpOUTb5YVTuz9i0Ly23V3krZJ4
         s3+yJFhQlvAzWznH9NOF9yeb1OY/gON3HE2YE=
MIME-Version: 1.0
In-Reply-To: <20101005075345.GF23608@elte.hu>
References: <20101001171719.4448E9D401B@zog.reactivated.net>
	<20101005075345.GF23608@elte.hu>
Date: Tue, 5 Oct 2010 15:36:42 +0100
X-Google-Sender-Auth: rS3rnucBFD25t41jBtaYehK47Hk
Message-ID: <AANLkTi=6HajpSvzogLQbqcyX8xR3Gy7aDu4_bHKEB8A=@mail.gmail.com>
Subject: Re: [PATCH] OLPC: Don't retry EC commands forever
From: Daniel Drake <dsd@laptop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        dilinger@queued.net, linux-kernel@vger.kernel.org,
        Paul Fox <pgf@laptop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 October 2010 08:53, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Daniel Drake <dsd@laptop.org> wrote:
>
>> From: Paul Fox <pgf@laptop.org>
>>
>> Avoids a potential infinite loop
>
> Was this infinite loop observed in practice? I.e. should this get into
> .36 and into -stable?

It was observed once, but only during an EC hacking/debugging session
- not in regular operation.
So it should be fine for the next merge window with no need to backport it.

Thanks,
Daniel
