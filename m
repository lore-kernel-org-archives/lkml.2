Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759271Ab0KRPuB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 10:50:01 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:56418 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758887Ab0KRPuA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 10:50:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=i6gMNmTTv1N7b4Rf8ylAxAuubKGSwDq3qjW0UhzQb/3eAUzJ0VdDMe7j70C6bsDRYT
         guheGbz/xss5NdwKMu1D3FHfmvuPtFTroI1XTPv7cGNaw6Bm7cnaxTAQlpFPEzHuVelj
         z61fFRTrOIaTxuMUCEYR+7p5Vs6xTCr/Perog=
MIME-Version: 1.0
In-Reply-To: <20101118153726.GA587@redhat.com>
References: <1290091494.1145.5.camel@gondor.retis>
	<20101118153726.GA587@redhat.com>
Date: Thu, 18 Nov 2010 16:49:59 +0100
Message-ID: <AANLkTikiM0wXoidn_qmhNLC2hJ+OK-W_SvKgUA8uUGaE@mail.gmail.com>
Subject: Re: [PATCH] cpu.c: remove unused variable
From: Dhaval Giani <dhaval.giani@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, akinobu.mita@gmail.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 4:37 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 11/18, Dhaval Giani wrote:
>>
>> --- linux-2.6.orig/kernel/cpu.c
>> +++ linux-2.6/kernel/cpu.c
>> @@ -197,7 +197,6 @@ struct take_cpu_down_param {
>>  static int __ref take_cpu_down(void *_param)
>>  {
>>       struct take_cpu_down_param *param = _param;
>> -     unsigned int cpu = (unsigned long)param->hcpu;
>>       int err;
>
> This is on top of Peter's patch, I guess.
>

current tip/master, so I guess so :-) Now if I can just figure out why
this configuration mess does not boot for me ;-)

Dhaval
