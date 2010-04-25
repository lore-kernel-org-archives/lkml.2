Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815Ab0DYPX2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 11:23:28 -0400
Received: from 26.mail-out.ovh.net ([91.121.27.225]:51273 "HELO
	26.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752342Ab0DYPX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 11:23:27 -0400
Message-ID: <4BD45E68.4080900@example.com>
Date: Sun, 25 Apr 2010 17:23:20 +0200
From: Piotr Hosowicz <piotr@hosowicz.com>
Reply-To: piotr@hosowicz.com
Organization: hosowicz.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100411 Icedove/3.0.4
MIME-Version: 1.0
To: sedat.dilek@gmail.com
CC: Sedat Dilek <sedat.dilek@googlemail.com>,
       LKML <linux-kernel@vger.kernel.org>, David Miller <davem@davemloft.net>,
       Jiri Olsa <jolsa@redhat.com>, Eric Dumazet <eric.dumazet@gmail.com>,
       Jongman Heo <jongman.heo@gmail.com>
Subject: Re: [2.6.34-rc5-git6] EIP: is at inet6_csk_bind_conflict + 06xe/0xb7
 	[ipv6]
References: <l2z2d0a357f1004250811w6da355ebp95d1730473026c22@mail.gmail.com>
In-Reply-To: <l2z2d0a357f1004250811w6da355ebp95d1730473026c22@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 6802968713357259168
X-Ovh-Remote: 83.6.189.87 (abaz87.neoplus.adsl.tpnet.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25.04.2010 17:11, Sedat Dilek wrote:
> [ Please CC - I am not subscribed to LKML ]
>
> [QUOTE]
>
> On 25.04.2010 16:26, Jongman Heo wrote:
>
>> I also hit this bug today.
>
> I also hit similar bug, maybe it is the same.
>
>> Doing git bisect, first bad commit was
>>
>>    commit fda48a0d7a8412cedacda46a9c0bf8ef9cd13559
>>    tcp: bind() fix when many ports are bound
>>
>> Reverting above commit fixes the problem.
>
> How to do it? Would you please publish a reverting patch?
>
> Regards,
>
> Piotr Hosowicz
>
> [/QUOTE]
>
> Hi,
>
> did forget to mention 2.6.34-rc5-git5 was OK.
>
> Revering this commit did not help:
>
> commit f4f914b58019f0e50d521bbbadfaee260d766f95
> net: ipv6 bind to device issue
>
> After looking into net-2.6 GIT repository, "tcp: bind() fix when many
> ports are bound" could cause indeed the problems here, too.
> Building now....
>
> Regards,
> - Sedat -
>
> P.S.: Attached 0001-Revert-tcp-bind-fix-when-many-ports-are-bound.patch

Thanks a lot. Applied and building now.

Regards,

Piotr Hosowicz

-- 
Z cyklu "Uroki demokracji", czyli pytania i odpowiedzi w teledurniejach:
- W którym kraju znajduje siê Mount Everest?
- Hm, to nie Szkocja, prawda?
NP: Mark Knopfler - Cleaning My Gun
NB: 2.6.34-rc5-git5
