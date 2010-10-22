Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698Ab0JVF6b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 01:58:31 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52511 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183Ab0JVF6a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 01:58:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mya+kPGPBopfz8SuKx9w/NX+a16va5TiZ3Q22z0D3L0tDI2rEab3K0Oe1R+t/sNn8G
         JPKWyhA0EIVisnZZGx3MoInwqRXJeRnY9I7r6gbjjvHpA8Tsv10HDsAmdJK7tArTgDq+
         P0IpTRZH7Inwjz7cnxuME4zOpl/QHxHjmlUrs=
MIME-Version: 1.0
In-Reply-To: <20101022025245.GJ23835@ghostprotocols.net>
References: <AANLkTi=vJArRbLup=F2duoxx47LFGTT3++4QiFZHJbzQ@mail.gmail.com>
	<20101022025245.GJ23835@ghostprotocols.net>
Date: Fri, 22 Oct 2010 01:58:29 -0400
Message-ID: <AANLkTinFjydPNSKiu_Zqao75udQGXN9pMgPq=SvGn36_@mail.gmail.com>
Subject: Re: why could cause PerfTop get nothing output ?
From: Luming Yu <luming.yu@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 21, 2010 at 10:52 PM, Arnaldo Carvalho de Melo
<acme@ghostprotocols.net> wrote:
> Em Sat, Oct 09, 2010 at 05:07:42AM -0400, Luming Yu escreveu:
>> Hi acme,
>>
>> I got nothing output as below, wondering if it was due to too few interrupts ?
>
> Try using a higher frequency:

Thanks for the hint.

>
> perf top -F 100000

still nothing..

-------------------------------------------------------------------------------
   PerfTop:       0 irqs/sec  kernel:-nan%  exact: -nan% [100000Hz
cycles],  (all, 2 CPUs)
-------------------------------------------------------------------------------

             samples  pcnt  DSO
             _______ _____


>> Is it possbile to get perf top based on samples from other Perf events?
>
> Yes, any event, just specify it like:
>
> perf top -e instructions

still nothing...

# perf top -e instructions

-------------------------------------------------------------------------------
   PerfTop:       0 irqs/sec  kernel:-nan%  exact: -nan% [1000Hz
instructions],  (all, 2 CPUs)
-------------------------------------------------------------------------------

             samples  pcnt  DSO
             _______ _____


>
> - Arnaldo
>
>> [root@localhost clocksource0]# rpm -qa | grep perf
>> perf-2.6.36-0.35.rc7.git0.fc15.x86_64
>> [root@localhost clocksource0]# uname -a
>> Linux localhost.localdomain 2.6.36-0.35.rc7.git0.fc15.x86_64 #1 SMP
>> Wed Oct 6 22:02:54 UTC 2010 x86_64 x86_64 x86_64 GNU/Linux
>> [root@localhost clocksource0]# perf top
>>
>> -------------------------------------------------------------------------------
>>    PerfTop:       0 irqs/sec  kernel:-nan%  exact: -nan% [1000Hz
>> cycles],  (all, 2 CPUs)
>> -------------------------------------------------------------------------------
>>
>>              samples  pcnt  DSO
>>              _______ _____
>
