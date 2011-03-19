Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013Ab1CSPS7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Mar 2011 11:18:59 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37991 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754500Ab1CSPS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Mar 2011 11:18:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=TUbSTC2E+u2TmrLCG7wyEYlXA/G9fyA8rX+lxAPe+WGVZW2AHdQgjooMtaOt+Y4anI
         bcf3+h9BTDF4GxQ6YhpYb9s1wJm2G0mor4v6IpeRp1/FmIvgznlJbczcHzN1pgotExP5
         1ubKAXncTt3fHzLiUgdIdcxpazsEh8AHZp/i8=
Subject: Re: No networking since git3
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Anca Emanuel <anca.emanuel@gmail.com>
Cc: piotr@hosowicz.com, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, Francois Romieu <romieu@fr.zoreil.com>,
        David Miller <davem@davemloft.net>, Oliver Neukum <oneukum@suse.de>
In-Reply-To: <AANLkTimFGeHYEOxx=h883rRJL463g1CBUDS0wGM-52Nj@mail.gmail.com>
References: <4D84A46B.1000407@example.com>
	 <AANLkTi=qrK2L+MA5F5fQ6S76LLPXkYhyLg7JL4_vrkRe@mail.gmail.com>
	 <4D84A9F6.8080402@example.com>
	 <AANLkTimFGeHYEOxx=h883rRJL463g1CBUDS0wGM-52Nj@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 19 Mar 2011 16:18:50 +0100
Message-ID: <1300547930.2831.27.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le samedi 19 mars 2011 à 16:08 +0200, Anca Emanuel a écrit :
> 2011/3/19 Piotr Hosowicz <piotr@hosowicz.com>:
> > On 19.03.2011 13:56, Anca Emanuel wrote:
> >>
> >> 2011/3/19 Piotr Hosowicz<piotr@hosowicz.com>:
> >>>
> >>> Hello,
> >>>
> >>> I wrote lately, the problem persists, that's why I write again. I tested
> >>> git7 just now and it still does not work.
> >>
> >> Same problem here:
> >>
> >> [   12.923685] r8169 0000:04:00.0: eth0: link down
> >> [   12.923941] ADDRCONF(NETDEV_UP): eth0: link is not ready
> >>
> >> dmesg attached.
> >
> > Nice to hear that I am not the only person with this problem. I forgot about
> > the dmesg.
> >
> > Regards,
> >
> > Piotr Hosowicz
> 
> Added CCs

Hi

Problem comes from commit 54405cde762408b00a445466a40da4f7f33a8479
(r8169: support control of advertising.)

Reverting it brings back NIC for me



