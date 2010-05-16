Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141Ab0EPQO2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 12:14:28 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:60868 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863Ab0EPQO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 12:14:27 -0400
Message-ID: <4BF019CF.1030309@biereigel-wb.de>
Date: Sun, 16 May 2010 18:14:07 +0200
From: Stefan Biereigel <security@biereigel-wb.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; de; rv:1.9.1.9) Gecko/20100317 Lightning/1.0b1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Donald Allen <donaldcallen@gmail.com>
CC: john stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: PROBLEM: tickless scheduling
References: <AANLkTin6D2GP0yJJbPYGH1AcAM9-g219rAxSyW_ZlrXV@mail.gmail.com>	 <AANLkTikjgoBQWqvNxncMUFqWOEXtq4ePvGkvF-m0sGUE@mail.gmail.com>	 <AANLkTimnlZYonxKzfGHZTV8vwaDptOPHEPBjNhwnV55Y@mail.gmail.com>	 <1273540344.3843.101.camel@localhost.localdomain>	 <AANLkTilg2cn3lAIOruz6oZE7V-9uAFDORlbvTX3qxmwF@mail.gmail.com>	 <AANLkTilb_CGBolyv5Ps9VuhNxFZKtjck4om4G21ICaif@mail.gmail.com>	 <1273697523.2856.3.camel@localhost.localdomain> <AANLkTinBPDY_WVGaq2LUuOzH0niRpgJ4LEpXWkwBxVqh@mail.gmail.com>
In-Reply-To: <AANLkTinBPDY_WVGaq2LUuOzH0niRpgJ4LEpXWkwBxVqh@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+nlsmZ+BZW+1rVbopk4bCaKPeFMpaSUm3oCwl
 XFh7ezYMGlikYK+CjE6IJ75UzFsX0aoCa8IvsVdP7zflTTs4Az
 QIRJElBEBADLClvfCLii5HifufTd0n8rJ+PYuFa1xA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Attached. This is from the 2.6.30 kernel on the Arch Linux install cd.
>
> Here's another bit of data. As I've said previously, the problems I'm
> reporting were observed on a Toshiba NB310-305 netbook with a
> single-core Atom 450 processor. I just built myself a mini-ITX system
> using the Intel D510MO motherboard, which provides a dual-core D510
> Atom processor. The other hardware on the board is similar to the
> Toshiba. I installed the same Slackware snapshot I used on the
> Toshiba, and did the home directory transfer without any problem at
> all with the default tickless kernel. The hardware isn't identical,
> and while I don't know the internals of the Linux kernel at all, my
> gut, backed up by many years of OS development work in scheduling and
> memory management, is telling me that the key difference is dual- vs.
> single-core. Just a guess.
>
> Hope this helps --
>
> /Don
>    
Hello everyone,

I hope I can add something here, because I am experiencing the exact 
same Problem as Don describes. I'm running a PackardBell EasyNote MB89 
featuring a Core 2 Duo, 4 GB of RAM, Intel Chipset (Santa Rosa), SATA 
HDD. My Machine even hangs at boot, absolutely doing nothing until i 
wiggle the touchpad. This is definately reproduceable, but I think it 
doesn't occur that often in X-Window-System, if X is off I can just wait 
a couple of seconds and there I go.

I compiled other kernels myself with tickless disabled and Ticks set to 
various values (250, 1000) which completely resolved my problem. If you 
want, I can get you some Output/logs/whatever because I'm fixed to using 
this kernel ATM (which doesn't really hurt because I use X and son't 
shut down my Notebook that often).
Even though I don't know what exact kernel-version this problem brings 
(using another machine ATM from vacation) I can say that I existed since 
Opensuse 11.1 I guess, so maybe 2.6.30 and above.

Hope I can help --

Stefan
