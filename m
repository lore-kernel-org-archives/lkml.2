Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756457Ab0GMVaX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 17:30:23 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46525 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081Ab0GMVaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 17:30:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=ZuEBHx2hOPSljQJ3bmNCnh4q0PCRgBGAc4VaJVb2cH/4o7hm7vRDQnEL8wtK1l+vLF
         dNsqZ6lQP0ACh/B3qZv4xVAUE3/vZEWLDDkp1aVa2nSCAs/oDG22YuwHVox3FUqwWPQf
         waHXP1IdcKGPmO72NhRiAHxo2ALaC1sjTDx18=
MIME-Version: 1.0
In-Reply-To: <20100713204235.GA32085@liondog.tnic>
References: <AANLkTin0mv0Z5vozJHkfVYCJTWMvj9JZnP_FcQ6vZBRV@mail.gmail.com>
	<20100713124840.GA16427@a1.tnic>
	<AANLkTimBhWKo0zxW6fX5RgLLAQVIdItS5RKpvxqkDlis@mail.gmail.com>
	<20100713151329.GA17516@a1.tnic>
	<cone.1279041124.439539.3902.1000@deskpiie>
	<AANLkTimiZcGY04wDK0yLtGrDknP-amyUaWybqsD5DHqC@mail.gmail.com>
	<20100713204235.GA32085@liondog.tnic>
Date: Tue, 13 Jul 2010 23:30:18 +0200
Message-ID: <AANLkTimZylbkjNKypCwVpvOneAUQMYBUtQ1su9BEuQ6Q@mail.gmail.com>
Subject: Re: acerhdf.c - unsupported notebook
From: Branislav Gajdos <brianzee@gmail.com>
To: Borislav Petkov <bp@alien8.de>, Branislav Gajdos <brianzee@gmail.com>,
        Peter Feuerer <peter@piie.net>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boris,

On Tue, Jul 13, 2010 at 10:42 PM, Borislav Petkov <bp@alien8.de> wrote:
>>
>> > I would propose to enhance the bios_tbl by the default temperatures. What do you think?
>>
>> So that means you would keep there the definitions for Core 2 based
>> models as well, right?
>
> You still didn't answer my question whether your fan is noisy? IOW, does
> it make sense for you to use this driver at all?

That's a good question. I didn't really investigate the fan noise. I
can probably make some observations and let you know in a couple of
days.

Branislav
