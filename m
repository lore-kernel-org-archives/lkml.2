Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755953Ab0KJTDM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 14:03:12 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48932 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754879Ab0KJTDK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 14:03:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=CzRV1mhFD5s/Tsezn7iuf5fcsmRALVtWqC6WTyKEN0HIMeTOorPaH2UKDbjH44Dnef
         HT9WNm3E8jc/59xC9TP8VjcBRP10pO1YEcntgdvb1Y188kND23JlFT5EaBouvI4dSI9l
         qdd4z+Ba8ylahkLq21dWMWxb3UvenpJ0JLhWg=
MIME-Version: 1.0
In-Reply-To: <20101110185031.GB13539@aftab>
References: <AANLkTikA6hZDV0A30fku7VT7Z1P8OqxcsF-EK95pBdD=@mail.gmail.com>
 <4CD966D8.4000602@ladisch.de> <20101109153805.GB3146@kryptos.osrc.amd.com>
 <AANLkTi=cUGGpkgWcbX=KMxzu+E=Toy_O+LeLoAFFUAsh@mail.gmail.com>
 <20101109180123.GB31121@aftab> <AANLkTik107mFOqvxsBtBrc14RHwhkkZTOGgctxKPPNfW@mail.gmail.com>
 <AANLkTik1JdQRh_Gkz_240csVGp4sS0W8nzR5d9Pv1G-X@mail.gmail.com> <20101110185031.GB13539@aftab>
From: Andrew Lutomirski <luto@mit.edu>
Date: Wed, 10 Nov 2010 14:02:48 -0500
X-Google-Sender-Auth: qJ8n8mGajbpMTCfore-2z1wZgO8
Message-ID: <AANLkTimNuSJz0nXZCR2zu963VQ_Y9R8ix73+QbbUy7nt@mail.gmail.com>
Subject: Re: [FALSE ALARM] Re: HPET (?) related hangs and breakage in 2.6.35,36
To: Borislav Petkov <bp@amd64.org>
Cc: Clemens Ladisch <clemens@ladisch.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, x86 <x86@kernel.org>,
        =?ISO-8859-1?Q?J=F6rg_R=F6del?= <joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 1:50 PM, Borislav Petkov <bp@amd64.org> wrote:
> On Wed, Nov 10, 2010 at 01:48:00PM -0500, Andrew Lutomirski wrote:
>> > Clocksource: tsc unstable (delta = -34355296774 ns)
>> > Switching: to clocksource hpet
>>
>> Please disregard -- this is a bug in nouveau (or drm) not hpet.  I'll
>> send a bug report to the maintainers.
>
> Interesting! Joerg was complaining about similar symptoms with .36 today
> too.

Well, there is a clocksource sort-of-bug that could cause confusion:
when something totally unrelated to clocksources goes out to lunch,
the clocksource watchdog decides that the clocksource is unstable and
complains, steering everyone toward filing the wrong bug.

tglx?

>
> --
> Regards/Gruss,
> Boris.
>
> Advanced Micro Devices GmbH
> Einsteinring 24, 85609 Dornach
> General Managers: Alberto Bozzo, Andrew Bowd
> Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
> Registergericht Muenchen, HRB Nr. 43632
>
