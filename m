Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631Ab0LNIfG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 03:35:06 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:35549 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754670Ab0LNIfF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 03:35:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xARxXFw1U2SHS8L9oVwb2l5cQtKtPnEjKH310suQGr1xTXcWAzRKZaLl6YkGh2RDGx
         DALuPI7KciS/1ZCrAWiI+PkNHkmjSKSOG27jK6XNwrUx7HpK/vMSur3u4fMl6cd2lJR1
         FNPhNYXFdzpOzVnuPS1ZlxJQHNoqQP8Wwlrtw=
MIME-Version: 1.0
In-Reply-To: <987664A83D2D224EAE907B061CE93D530193BBAA27@orsmsx505.amr.corp.intel.com>
References: <AANLkTin2Z5XXf-3Gkqj72+FT4rM+hpqehK8Ys=gg++c9@mail.gmail.com>
	<987664A83D2D224EAE907B061CE93D530193BBAA27@orsmsx505.amr.corp.intel.com>
Date: Tue, 14 Dec 2010 09:35:02 +0100
Message-ID: <AANLkTi=NKa6UCeYsE0Y5iWnq8XYbVtSU7XiKJSNc5tLz@mail.gmail.com>
Subject: Re: [RFC] persistent store (version 3) (part 1 of 2)
From: Marco Stornelli <marco.stornelli@gmail.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/12/13 Luck, Tony <tony.luck@intel.com>:
>>could you cc linux fs devel and maybe linux embedded mailing list?
>>Currently I try to insert in mainline the pramfs. Maybe we have the
>>same goal and we could "merge" our effort. What do you think? Sure the
>>kernel from this point of view has got a lack of support, I see
>>different approach and solution to this. I saw in the staging tree a
>>pmem driver of google guys that it seems to be designed for the same
>>goal.
>
> Marco,
>
> My Cc: list is already getting rather long ... I worry about
> adding more mailing lists to it.  Embedded is a bit worrying
> for me as I've been a bit cavalier about memory allocation in
> the current version (on the theory that I was targeting servers,
> and a few Kbytes, or even tens of Kbytes wasn't worth worrying
> about on a server - which these days is likely to have a minimum
> of 4 GBytes).
>
> I grepped around for "pmem" in drivers/staging in linux-next and
> got a lot of hits - but none of them leapt out as something
> similar.  Can you point a bit more specifically?

I saw (very quickly) in drivers/staging/dream/pmem.c

Marco
