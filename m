Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622Ab0K3UJl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 15:09:41 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:64291 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756127Ab0K3UJj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 15:09:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=CeEMxjAwpkFbs+lXbTmMRv5URmV2VWqRYKwNZmqGCD6QwgcJqzRGutntwudutFxt7q
         jty4DGv7uBIPcykQb1DlqGVBimdEoL0C71+rhDcNARC7JL37YJAEJWRWDKGL/+6BL1+4
         Qg21DehIAX3pfmZbv2xJa26v5x6fQQZRoGzmY=
MIME-Version: 1.0
In-Reply-To: <20101130200019.GA28735@elf.ucw.cz>
References: <AANLkTim4jVaZxYp8nSgJyy28iwxcxbPeNUzxTfoHAX4S@mail.gmail.com>
 <20101118113441.74fcdc21@lxorguk.ukuu.org.uk> <AANLkTikOZbtyhsk0OBb4OdUi6qj-7k_hU-aW_Pkhfpq0@mail.gmail.com>
 <20101130192648.GA1623@ucw.cz> <AANLkTinMyAeVJJc7Lc-vt_Ywr+vcSf-GAiQwggTGbqh8@mail.gmail.com>
 <20101130200019.GA28735@elf.ucw.cz>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Tue, 30 Nov 2010 12:09:18 -0800
X-Google-Sender-Auth: 0VrgQkbxPCrQEA_BEveFxzIi-Og
Message-ID: <AANLkTi=bs3ev9A2RQdKujVsDrpQJCCRZ+e2BzYeFNmD_@mail.gmail.com>
Subject: Re: Challenges with doing hardware bring up with Linux first
To: Pavel Machek <pavel@ucw.cz>
Cc: bkuhn@ebb.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Greg KH <greg@kroah.com>, David Miller <davem@davemloft.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        "Perez-Gonzalez, Inaky" <inaky.perez-gonzalez@intel.com>,
        Charles Marker <Charles.Marker@atheros.com>,
        Jouni Malinen <Jouni.Malinen@atheros.com>,
        Kevin Hayes <kevin@atheros.com>, Zhifeng Cai <zhifeng.cai@atheros.com>,
        Don Breslin <Don.Breslin@atheros.com>,
        Doug Dahlby <Doug.Dahlby@atheros.com>, Julia Lawall <julia@diku.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 30, 2010 at 12:00 PM, Pavel Machek <pavel@ucw.cz> wrote:
> On Tue 2010-11-30 11:30:18, Luis R. Rodriguez wrote:
>> On Tue, Nov 30, 2010 at 11:26 AM, Pavel Machek <pavel@ucw.cz> wrote:
>> > Hi!
>> >
>> >> >> everything else can be independent code. For ath9k in particular this
>> >> >> means we keep ath9k_hw shared between our Operating Systems and that's
>> >> >> it. In addition to this I believe opening up the common drivers for
>> >> >
>> >> > The Linux copy needs to be GPL,
>> >>
>> >> GPL-Compatible you mean, right. I mean we have ath9k_hw with
>> >> permissive licensed files.
>> >
>> > GPL-compatible is not right word. It has to be either GPL, or so
>> > permissive that anyone is allowed to turn it into GPL.
>>
>> Oh?
>
> Kernel is GPL. Dual BSD/GPL is ok. Just BSD... I don't think so.
>
> /*
>  * Copyright (c) 2008 Atheros Communications Inc.
>  *
>  * Permission to use, copy, modify, and/or distribute this software
> for any
>  * purpose with or without fee is hereby granted, provided that the
> above
>  * copyright notice and this permission notice appear in all copies.
>  *
>
> ...but I need permission to relicense it under GPL, and I'm not sure I
> have it.

Got it, OK let me clarify that for you then. Yes. That is what makes
it GPL-Compatible. We droped the Dual GPL/BSD practice and picked up
the ISC license to help OpenBSD when we took Reyk's HAL from OpenBSD.
The ISC license is just a simpler BSD license due the Berne Convention
which makes one of the clauses implicit (respecting copyright between
countries). Its just a very simple permissive license.

 Luis
