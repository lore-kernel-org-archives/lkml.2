Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750969Ab0ENEBu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 00:01:50 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:35031 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716Ab0ENEBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 00:01:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=JTBz51IadYK79K7fqGe69NoXS9o5uLdBG51gUYBa2LNehwQdEhTo25fyPuj6Ph4TNL
         xje0bp2cK8Ywmk6M+ud2ce+zcki4k9sMVeUA6uAlWPPXhEV2e4PbpxEUguN+oauluK5t
         T/++f4+nqivWgJO0hzo5MaVdkdB3ZWpRoz8uo=
MIME-Version: 1.0
In-Reply-To: <4BECB1F2.5050900@gmail.com>
References: <4BEC7A84.3010503@gmail.com> <AANLkTinKoMxdkPYQA_AblpByL6zAiAP5hv2M3Jn2R3hM@mail.gmail.com> 
	<4BEC9E6B.30809@gmail.com> <201005141008.20667.br1@einfach.org> 
	<4BECA3AE.4070607@gmail.com> <20100514012314.GA2170@tux> <4BECA6AC.9060609@gmail.com> 
	<20100514014311.GC2170@tux> <20100514014553.GD2170@tux> <4BECB1F2.5050900@gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 13 May 2010 21:01:27 -0700
X-Google-Sender-Auth: CWC25BEnuxYZzLCoOelczTmxD_k
Message-ID: <AANLkTilOJMtg1EIlDgY3_T5Xb6Zed0tbqkD7CGr7utol@mail.gmail.com>
Subject: Re: ath9k: BUG kmalloc-8192: Poison overwritten
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
       Bruno Randolf <br1@einfach.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 13, 2010 at 7:14 PM, Justin P. Mattock
<justinmattock@gmail.com> wrote:

>
> what I can try, is(not at the convention, on eth0
> at the moment), but when I get back to the convention
> center place I can try your patch as well as the
> modprobe option, to see if I can get any signs of
> a recreation(if so I'll bisect there).

The debug info I just need upon load of the module, I don't need you
to run the debug stuff to try to reproduce. The debug print upon load
will tell us the rxbuf size and cache line size.

  Luis
