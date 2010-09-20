Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756506Ab0ITOtc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 10:49:32 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:54286 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119Ab0ITOtb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 10:49:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=inrlE9wI3QMjEE+vCl+5Qfb/myKCRTOrs1/qweQUiicTi5r7AYTuQyAgeJFLy/XwHy
         JHH9/gWEnVAcrg/CUYVPNj5uwS27EVHZEJED6gPaBFV1wt2p3ldMEOZUvHEJRoaON/tC
         Jdjop/5OQrlMJGcLgICPuLLLLY6FVQZYblIo8=
MIME-Version: 1.0
In-Reply-To: <4C972FE5.2070103@cam.ac.uk>
References: <cover.1284937055.git.joe@perches.com> <33b49e667f4b875a383dd5ba1db168b6ce8225ec.1284937055.git.joe@perches.com>
 <4C972FE5.2070103@cam.ac.uk>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Mon, 20 Sep 2010 22:49:10 +0800
Message-ID: <AANLkTi=MUyeb4rSz6X8PrWM7uEgCu6m1i3JzuuU=B7pW@mail.gmail.com>
Subject: Re: [PATCH 2/6] MAINTAINERS: Merge imote2 and stargate
To: Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Cameron <jic23@cam.ac.uk>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 20, 2010 at 5:56 PM, Jonathan Cameron <jic23@cam.ac.uk> wrote:
> On 09/20/10 00:10, Joe Perches wrote:
>> Removed by commit dcd925f95194da42e42cea7e5f901f9746cf441c
>>
>> CC: Jonathan Cameron <jic23@cam.ac.uk>
>> CC: Eric Miao <eric.y.miao@gmail.com>
> Doh!  Good point, I forgot about the MAINTAINERS file when I did that
> merge. Thanks Joe,
>
>>
>> Signed-off-by: Joe Perches <joe@perches.com>
> Acked-by: Jonathan Cameron <jic23@cam.ac.uk>

Andrew,

Would be appreciated if you could help merge this. Thanks.

>> ---
>>  MAINTAINERS |    8 +-------
>>  1 files changed, 1 insertions(+), 7 deletions(-)
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index a9f0567..03929b5 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -755,13 +755,7 @@ L:       linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
>>  S:   Maintained
>>  F:   arch/arm/mach-ixp4xx/
>>
>> -ARM/INTEL RESEARCH IMOTE 2 MACHINE SUPPORT
>> -M:   Jonathan Cameron <jic23@cam.ac.uk>
>> -L:   linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
>> -S:   Maintained
>> -F:   arch/arm/mach-pxa/imote2.c
>> -
>> -ARM/INTEL RESEARCH STARGATE 2 MACHINE SUPPORT
>> +ARM/INTEL RESEARCH IMOTE/STARGATE 2 MACHINE SUPPORT
>>  M:   Jonathan Cameron <jic23@cam.ac.uk>
>>  L:   linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
>>  S:   Maintained
>
>
>
>
