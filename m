Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756980Ab0ENCqL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 22:46:11 -0400
Received: from mail-yw0-f198.google.com ([209.85.211.198]:65163 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316Ab0ENCqI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 22:46:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=IZeigzIVU4MoE3wW4LT4Rus3icM2q+4IL2+aQBMzq32gDCIFbNF9jZwRJBIfiDAYP5
         G/0ZsZTplXM/BlSTYXT/Y3t/rJLEqXHmnNvOFjiKlPUiOlukOeVc7BP7i/zkMBHOAv2m
         Nq0Ye4qnI20uCbl0bbgOyyjOARwZ+w5EWRG5M=
MIME-Version: 1.0
In-Reply-To: <1273776201.11899.23.camel@sven.thebigcorporation.com>
References: <AANLkTinbwZK5Tp6aI4ja38XaiiB5aIyECzHPdMpvkaIy@mail.gmail.com>
	 <1273776201.11899.23.camel@sven.thebigcorporation.com>
Date: Fri, 14 May 2010 08:16:07 +0530
Message-ID: <AANLkTilMrwdaLrTAUVETYZLYSpoqVFVXfKZ2lZit6uG3@mail.gmail.com>
Subject: Re: preempt_disable and sleep()
From: ratheesh k <ratheesh.ksz@gmail.com>
To: Sven-Thorsten Dietrich <thebigcorporation@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 14, 2010 at 12:13 AM, Sven-Thorsten Dietrich
<thebigcorporation@gmail.com> wrote:

> Why would you do this?
I was reading some linux kernel journel about preempt_disable() . This
a doubt came to me .


> If you had tried this code, you would have seen the corresponding stack
> dump on the console.


Why it so .? could you explain a little more ? .sleep() will schedule
() , which inturn give back control to kernel .

Thank,
Ratheesh

On Fri, May 14, 2010 at 12:13 AM, Sven-Thorsten Dietrich
<thebigcorporation@gmail.com> wrote:
> On Fri, 2010-05-14 at 00:02 +0530, ratheesh k wrote:
>> I am running RT linux .
>>
>> /* code snippet */
>>
>> preempt_disable()
>> ...........
>> sleep(10);
>> '............
>> preempt_enable()
>>
>>
>> will this sleep() will cause reschedule ?.
>>
>
> Why would you do this?
>
> If you had tried this code, you would have seen the corresponding stack
> dump on the console.
>
>> if an interrupt comes  while premption is disabled , how it is handled ?.
>>
>
> Depends on the number of (idle) cores, the setting of CONFIG_PREEMPT_[]
> and the type of interrupt.
>
> RT threaded IRQs would not run until preemption is enabled on a single
> core system.
>
>
>
>> Thanks,
>> Ratheesh
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
