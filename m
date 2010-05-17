Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273Ab0EQP0c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 11:26:32 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:62962 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185Ab0EQP03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 11:26:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=OjvPZ0QTZ0XCsajKHGD7hDCwtRd4KBxcQnlSm/qH2cF1E5uSxn8xBeHom6atobwswT
         rpnYPt/W7aYggafDOqaZYcwtbMdkkdr43ajiaz7lNqnWKITBqxvxynHg51xRiimjivaU
         ielUw9IPXqBKGQMIvyNoLeC2brLCWdzsf8qHI=
MIME-Version: 1.0
In-Reply-To: <4BF019CF.1030309@biereigel-wb.de>
References: <AANLkTin6D2GP0yJJbPYGH1AcAM9-g219rAxSyW_ZlrXV@mail.gmail.com>
	 <AANLkTikjgoBQWqvNxncMUFqWOEXtq4ePvGkvF-m0sGUE@mail.gmail.com>
	 <AANLkTimnlZYonxKzfGHZTV8vwaDptOPHEPBjNhwnV55Y@mail.gmail.com>
	 <1273540344.3843.101.camel@localhost.localdomain>
	 <AANLkTilg2cn3lAIOruz6oZE7V-9uAFDORlbvTX3qxmwF@mail.gmail.com>
	 <AANLkTilb_CGBolyv5Ps9VuhNxFZKtjck4om4G21ICaif@mail.gmail.com>
	 <1273697523.2856.3.camel@localhost.localdomain>
	 <AANLkTinBPDY_WVGaq2LUuOzH0niRpgJ4LEpXWkwBxVqh@mail.gmail.com>
	 <4BF019CF.1030309@biereigel-wb.de>
Date: Mon, 17 May 2010 11:26:28 -0400
Message-ID: <AANLkTinDvxfub_CBYQru7yi9KAAjjf5Q4emme0VXSErG@mail.gmail.com>
Subject: Re: PROBLEM: tickless scheduling
From: Donald Allen <donaldcallen@gmail.com>
To: Stefan Biereigel <security@biereigel-wb.de>
Cc: john stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan --

Would you check the BIOS on your machine and report the maker and
version number? If you've followed this, I'm especially interested to
know if it's a Phoenix BIOS.

Thanks --
/Don

On Sun, May 16, 2010 at 12:14 PM, Stefan Biereigel
<security@biereigel-wb.de> wrote:
>
>> Attached. This is from the 2.6.30 kernel on the Arch Linux install cd.
>>
>> Here's another bit of data. As I've said previously, the problems I'm
>> reporting were observed on a Toshiba NB310-305 netbook with a
>> single-core Atom 450 processor. I just built myself a mini-ITX system
>> using the Intel D510MO motherboard, which provides a dual-core D510
>> Atom processor. The other hardware on the board is similar to the
>> Toshiba. I installed the same Slackware snapshot I used on the
>> Toshiba, and did the home directory transfer without any problem at
>> all with the default tickless kernel. The hardware isn't identical,
>> and while I don't know the internals of the Linux kernel at all, my
>> gut, backed up by many years of OS development work in scheduling and
>> memory management, is telling me that the key difference is dual- vs.
>> single-core. Just a guess.
>>
>> Hope this helps --
>>
>> /Don
>>
>
> Hello everyone,
>
> I hope I can add something here, because I am experiencing the exact same
> Problem as Don describes. I'm running a PackardBell EasyNote MB89 featuring
> a Core 2 Duo, 4 GB of RAM, Intel Chipset (Santa Rosa), SATA HDD. My Machine
> even hangs at boot, absolutely doing nothing until i wiggle the touchpad.
> This is definately reproduceable, but I think it doesn't occur that often in
> X-Window-System, if X is off I can just wait a couple of seconds and there I
> go.
>
> I compiled other kernels myself with tickless disabled and Ticks set to
> various values (250, 1000) which completely resolved my problem. If you
> want, I can get you some Output/logs/whatever because I'm fixed to using
> this kernel ATM (which doesn't really hurt because I use X and son't shut
> down my Notebook that often).
> Even though I don't know what exact kernel-version this problem brings
> (using another machine ATM from vacation) I can say that I existed since
> Opensuse 11.1 I guess, so maybe 2.6.30 and above.
>
> Hope I can help --
>
> Stefan
>
