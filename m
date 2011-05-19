Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933431Ab1ESOYH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 10:24:07 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:59545 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932671Ab1ESOYF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 10:24:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=CcFH2r1P7AybpM6ktMgOzmLyhbg936b/mayXV1lsrzBdFxRdsobYwOw8dONwNqIigK
         NwGmI7KzU0PUJnlxRt/QYM4Fo5kDnA2IcAyiqRCwB30oJC+qELr/EumqP8M2Ne6NaQmN
         UASZFwuTwkww6l2aEIZrb+dyJfrUvbzKco6lo=
MIME-Version: 1.0
In-Reply-To: <201105191550.20129.arnd@arndb.de>
References: <201105181047.17309.arnd@arndb.de> <alpine.LFD.2.00.1105182234130.14430@xanadu.home>
 <BANLkTinXQvrG3LeSEO9Lnam3Bvq3dDKOsw@mail.gmail.com> <201105191550.20129.arnd@arndb.de>
From: Barry Song <21cnbao@gmail.com>
Date: Thu, 19 May 2011 22:23:43 +0800
Message-ID: <BANLkTikKhZu_H_QT+Uds22sepk1OnEeDNA@mail.gmail.com>
Subject: Re: [RFC] ARM Subarchitecture group maintainership
To: Arnd Bergmann <arnd@arndb.de>
Cc: Nicolas Pitre <nico@fluxnic.net>, linux-arm-kernel@lists.infradead.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/19 Arnd Bergmann <arnd@arndb.de>:
> On Thursday 19 May 2011, Barry Song wrote:
>> 2011/5/19 Nicolas Pitre <nico@fluxnic.net>:
>> > On Thu, 19 May 2011, Barry Song wrote:
>> > Something like that.  The exact details will be fleshed out as we go.
>> > The idea is to give a round of review from a higher point of view to
>> > make sure no opportunities for code reuse is missed, etc.  The mechanics
>> > of how this code transitions from this tree into mainline during the
>> > merge window is secondary.
>>
>> i asked this because we wanted to send the source codes of
>> CSR(http://www.csr.com) to upstream as i have told you in LDS. it
>> looks like we need to follow the below new changes to make our source
>> codes acceptable?
>> 1. arm device tree
>> 2. new pinmux framework from Linus Walleij
>> 3. move GPIO from plat/mach to drivers/gpio?
>
> I would count at least the last two as mandatory, for the device tree,
> it depends on how much work it would be for you to do the conversion
> and at what time you submit the series. The longer you wait before
> submitting the series, the stricter the requirements will get.
>
> Do you have a diffstat or a git tree with your work available?

not yet by now. it should be coming in the middle of next month. we
have workable codes but need a lot of refinations before sending
patches for review. it is more like a new begin from scratch, so
arm/arch changes should be things we can catch.

>
>        Arnd
>
