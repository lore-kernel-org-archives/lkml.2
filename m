Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751298Ab0KBIaU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 04:30:20 -0400
Received: from mail-yx0-f194.google.com ([209.85.213.194]:49224 "EHLO
	mail-yx0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208Ab0KBIaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 04:30:14 -0400
X-Greylist: delayed 2858 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Nov 2010 04:30:14 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=fAmybt+nqZB2FWAYxnsitWpf0lTgxu6v9B0qaNRgCgbkcF5b2Lv2rx4pSMmFV2EnMa
         w9rDohGF1If3vXnAp1EQeVvKU4x4PPm8SgLHsjFRYH6+JJkuOsqaSFzZOx0zGFoCtRA1
         CjKdAecc9WdL3gOsiu7TwKPq28GnKf+m5Vr28=
MIME-Version: 1.0
In-Reply-To: <20101101220033.416.qmail@stuge.se>
References: <AANLkTikbEgfVZmnVfbgGxbybbghXCuUgvEm03HH=i4HD@mail.gmail.com>
	<20101101160529.GA9306@comet.dominikbrodowski.net>
	<20101101220033.416.qmail@stuge.se>
Date: Tue, 2 Nov 2010 15:26:42 +0800
Message-ID: <AANLkTikBh3qAifA8U9--VyXZpD-vt3cuCj0M6npD4M3D@mail.gmail.com>
Subject: Re: PATCH : linux-2.6.35.4 drivers pcmcia cs.c
From: guillermo arias <papaguillee18@gmail.com>
To: guillermo arias <papaguillee18@gmail.com>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, linux-pcmcia@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To Dominic Brodowski :.
> it would enable CardBus on all PCMCIA bridges .
comment :.
"if (!(skt->features || SS_CAP_CARDBUS))" : refuse to enable in any
error(1) condition from "pc or kernel" .

To Peter Stuge :.
>Is it certain that the hardware *is* actually cardbus capable? .
comment :.
was probed with vpn .

Thanks to you .

//Guillermo



On 11/2/10, Peter Stuge <peter@stuge.se> wrote:
> Dominik Brodowski wrote:
>> indeed, on a IBM ThinkPad 770Z there seems to be some bug -- the CardBus
>> hardware doesn't tell the OS that it is CardBus capable.
>
> What hardware is this, and how would it tell the OS?
>
> Is it certain that the hardware *is* actually cardbus capable?
>
>
>> 2) What's the output of "lspci -n -v"
>> 3) What's the output of "sudo lspcmcia -vvv"
>
> Yes please.
>
>
>> 4) Are there any BIOS options you may toggle to enable CardBus?
>
>
> //Peter
>
