Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254Ab0KWXZe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 18:25:34 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:41792 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324Ab0KWXZd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 18:25:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=phrMzMKKCNasP2hBALsdZaWgI0ckiN89/Eh6eY2cZGD24nmgszxhSM5iU3kT6gNsyb
         PnIr6BCb+mX/diNY6qNEZzU11V+vzJ8mkFi0qiJE10Znhl51k/EILJcfK78U8A4fFZDJ
         n+7rsX5kerbl+XWwujWylrsm+BZjlHvUfl2q8=
MIME-Version: 1.0
In-Reply-To: <1290553918.2866.80.camel@edumazet-laptop>
References: <AANLkTi=Q967xpX0KLMwX-=_4_1AKO5wjHEuJ1TrNjCj9@mail.gmail.com>
	<1290553918.2866.80.camel@edumazet-laptop>
Date: Wed, 24 Nov 2010 00:25:32 +0100
Message-ID: <AANLkTimhCumpPDktqLF9c19DP8Eh3f8PP-89zeGfpHNM@mail.gmail.com>
Subject: Re: Unix socket local DOS (OOM)
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eugene Teo <eugene@redhat.com>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 November 2010 00:11, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Le mardi 23 novembre 2010 à 23:21 +0100, Vegard Nossum a écrit :
>> Hi,
>>
>> I found this program lying around on my laptop. It kills my box
>> (2.6.35) instantly by consuming a lot of memory (allocated by the
>> kernel, so the process doesn't get killed by the OOM killer). As far
>> as I can tell, the memory isn't being freed when the program exits
>> either. Maybe it will eventually get cleaned up the UNIX socket
>> garbage collector thing, but in that case it doesn't get called
>> quickly enough to save my machine at least.

>
> Hi Vegard
>
> Do you have a patch to correct this problem ?

No, sorry, I didn't look into it.


Vegard
