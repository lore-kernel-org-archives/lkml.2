Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342Ab0IOTbE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 15:31:04 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:60440 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639Ab0IOTbB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 15:31:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Qqay0HLpowGKxYFUbpM7MNJGuoPvfO2GLcVyii+C2qkvVaWV9fbiwZWy8my1eVXfgp
         Fkd3wSRzQKRXSj+5IeDvZaI4dEszirOPSZNp6tgutUgCHvzi1Vow+2dAmnppUiM0gix7
         JCZxh22ba8Q+lNPv7FDzceYyktIyHsHPb6nmA=
MIME-Version: 1.0
In-Reply-To: <37141.91.60.150.116.1284563403.squirrel@www.firstfloor.org>
References: <37141.91.60.150.116.1284563403.squirrel@www.firstfloor.org>
Date: Wed, 15 Sep 2010 21:30:56 +0200
X-Google-Sender-Auth: yW1XSGKMGhT8bXn_dmFYg_-7_Gs
Message-ID: <AANLkTik=rm-Y1BMAP6qOM-ppLrptP_hP-6jMeNV1uVkx@mail.gmail.com>
Subject: Re: [PATCH -tip -v4] irq_work: generic hard-irq context callbacks
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Huang Ying <ying.huang@intel.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        paulus <paulus@samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dhowells <dhowells@redhat.com>, Russell King <rmk@arm.linux.org.uk>,
        Kyle McMartin <kyle@mcmartin.ca>, davem <davem@davemloft.net>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Matt Fleming <matt@console-pimps.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 15, 2010 at 17:10, Andi Kleen <andi@firstfloor.org> wrote:
>> On Wed, 2010-09-15 at 13:29 +0800, Huang Ying wrote:
>>> I uses the cross build tool from:
>>>
>>> http://www.kernel.org/pub/tools/crosstool/
>>
>> I'm not familiar with those, I build my own gcc-4.5.1 toolchains for all
>> targets that would actually build a gcc toolchains, for those that don't
>> I simply don't care about.
>
> I don't think it's a reasonable requirement to have every contributor
> compile on all architectures. If that was a general requirement
> soon nobody would send patches anymore.
>
> Cross arch breakages happen rarely and can be usually repaired after
> the fact.

As long as "the fact" is linux-next and not Linus' tree, we can live
with that ;-)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
