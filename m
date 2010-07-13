Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174Ab0GMUaS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 16:30:18 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35560 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906Ab0GMUaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 16:30:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=cUOAorh//62zgRoL4OLEr4DBjzPCaQYQvhmKRc4x6eac1+KyL1kQ7gXPfZllRq81Cv
         /7yoJZko1GzvHGjHVIIw4kcWiBPJrj8SO2uD7Gm1wISERnkBAQazy6junlMMvUl6lPZU
         qoK5vaTpdpLQsrRgD8txYwZ+UNO772MEaONjU=
MIME-Version: 1.0
In-Reply-To: <cone.1279041124.439539.3902.1000@deskpiie>
References: <AANLkTin0mv0Z5vozJHkfVYCJTWMvj9JZnP_FcQ6vZBRV@mail.gmail.com>
	<20100713124840.GA16427@a1.tnic>
	<AANLkTimBhWKo0zxW6fX5RgLLAQVIdItS5RKpvxqkDlis@mail.gmail.com>
	<20100713151329.GA17516@a1.tnic>
	<cone.1279041124.439539.3902.1000@deskpiie>
Date: Tue, 13 Jul 2010 22:30:14 +0200
Message-ID: <AANLkTimiZcGY04wDK0yLtGrDknP-amyUaWybqsD5DHqC@mail.gmail.com>
Subject: Re: acerhdf.c - unsupported notebook
From: Branislav Gajdos <brianzee@gmail.com>
To: Peter Feuerer <peter@piie.net>
Cc: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Tue, Jul 13, 2010 at 7:12 PM, Peter Feuerer <peter@piie.net> wrote:
>>
>>> >> acerhdf: unknown (unsupported) BIOS version Acer/Aspire 3810T/V1.04,
>>> >> please report, aborting!
>
> Which distribution do you use? Does the distribution somehow autoload
> acerhdf? Or do you manually load the driver?

I compiled the kernel myself and chose the driver as my notebook was
Acer Aspire, I didn't realize it was meant only for netbooks :-)

> I would propose to enhance the bios_tbl by the default temperatures. What do you think?

So that means you would keep there the definitions for Core 2 based
models as well, right?

Branislav
