Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580Ab0H3Hi5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 03:38:57 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:42824 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760Ab0H3Hiz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 03:38:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=a+iaRdPwU9cVtxnenORlOOh3gw1Ej8Da53MoHqiHEvtX4N+UzI4Lpgi9va7wqf8dq9
         hjwnn11c807C3mspQ2104qpoKfHBez8V+7byFFzd45zQeIDEhqOpoGM6uWbwIvtbgwWy
         XgeRxrYStvyBKaGvsTWBmxfOpa2wwhp2uFTWI=
MIME-Version: 1.0
In-Reply-To: <4C7AF2C4.9040507@gmail.com>
References: <c1_O4wHrlB.A.63.mbueMB@chimera>
	<ByD_7B96czP.A.3DD.5fueMB@chimera>
	<4C7AF2C4.9040507@gmail.com>
Date: Mon, 30 Aug 2010 10:38:54 +0300
Message-ID: <AANLkTinzVmtWhhvuRNcKF1xKs+L=Lw0DT2osDxcbA6ze@mail.gmail.com>
Subject: Re: [Bug #16337] general protection fault: 0000 [#1] SMP
From: Pauli Nieminen <suokkos@gmail.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 30, 2010 at 2:52 AM, Justin P. Mattock
<justinmattock@gmail.com> wrote:
> On 08/29/2010 04:13 PM, Rafael J. Wysocki wrote:
>>
>> This message has been generated automatically as a part of a report
>> of regressions introduced between 2.6.34 and 2.6.35.
>>
>> The following bug entry is on the current list of known regressions
>> introduced between 2.6.34 and 2.6.35.  Please verify if it still should
>> be listed and let the tracking team know (either way).
>>
>>
>> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16337
>> Subject         : general protection fault: 0000 [#1] SMP
>> Submitter       : Justin P. Mattock<justinmattock@gmail.com>
>> Date            : 2010-07-03 22:59 (58 days old)
>> Message-ID      :<<4C2FC0E3.6050101@gmail.com>>
>> References      : http://marc.info/?l=linux-kernel&m=127819798215589&w=2
>>
>>
>>
>
>
> only have seen this once..on the other hand (If im correct)maciej or pauli
> where able to reproduce this.. I say leave open then go from there.
>
> Justin P. Mattock
>

I was able to reproduce this with about 50% chance in boot. But that
happened in a few rc (rc2-rc4 iirc) versions only. After that never
again.
