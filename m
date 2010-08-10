Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932350Ab0HJQK1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 12:10:27 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45582 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932130Ab0HJQKV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 12:10:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=IqXQJuP+481wJxQU9LyoDVQzmC7SqyRD1uo3iQXXDh0ZEAnzehrS/LBUnEpERfxk8A
         exAVTTAYnMOMIlc0wxCRta00DAsMeENSM9SRLX6oV5rtnjV1xYJjZod0n8jLs4osPq1o
         tJBDSTFl5hp3be1vGls4t1e5Uhd3f1QZ7WaNE=
MIME-Version: 1.0
In-Reply-To: <op.vg7o05wa7p4s8u@pikus>
References: <6f90103dea29739de0f4f0ede3f3da68afe84343.1281295424.git.mina86@mina86.com>
	<419733287a42072a658f0f74d0b1901132178b75.1281295424.git.mina86@mina86.com>
	<201008100615.52510.vda.linux@googlemail.com>
	<op.vg7o05wa7p4s8u@pikus>
Date: Tue, 10 Aug 2010 18:10:19 +0200
Message-ID: <AANLkTikQ-wHU0eGeteh4mWJj8E=iyhR8TDCnop1bi5Ey@mail.gmail.com>
Subject: Re: [PATCHv2 2/3] lib: vsprintf: optimised put_dec() for 32-bit 
	machines
From: Denys Vlasenko <vda.linux@googlemail.com>
To: =?ISO-8859-2?Q?Micha=B3_Nazarewicz?= <m.nazarewicz@samsung.com>
Cc: Michal Nazarewicz <mina86@mina86.com>, linux-kernel@vger.kernel.org,
        "Douglas W. Jones" <jones@cs.uiowa.edu>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/8/10 Michał Nazarewicz <m.nazarewicz@samsung.com>:
>>> +#if BITS_PER_LONG != 32 || defined CONFIG_CC_OPTIMIZE_FOR_SIZE || \
>>> +       ULLONG_MAX != 18446744073709551615ULL
>>
>> I think it's better to say "if BITS_PER_LONG > 32 and ULLONG_MAX >
>> 2^64-1",

Thinko. I meant "or", not "and"...

-- 
vda
