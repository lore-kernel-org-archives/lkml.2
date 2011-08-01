Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599Ab1HAGIq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 02:08:46 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:51889 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266Ab1HAGIo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 02:08:44 -0400
MIME-Version: 1.0
In-Reply-To: <CAPM=9tznbmkMnTcUDw-KAGeZQcqyZpsNwb74-JV9Y-d0Z3Sg1w@mail.gmail.com>
References: <20110724130336.GA2116@ime.usp.br>
	<CAPM=9txTVVxvv85kcZqBVjmpVK1zsAvVarLv1Sm7viwfF+ZYyA@mail.gmail.com>
	<67AE5A41-F50F-4616-B9E1-437CAD9379D3@ime.usp.br>
	<CAPM=9tznbmkMnTcUDw-KAGeZQcqyZpsNwb74-JV9Y-d0Z3Sg1w@mail.gmail.com>
Date: Mon, 1 Aug 2011 03:08:43 -0300
X-Google-Sender-Auth: 1OULsBwDMM8GgQj04QYqo6NsuTU
Message-ID: <CAOtrxKPXk6KDkzLF7hxxn0OxLV7y=6zSM67fcnJMvmL2KkVf1A@mail.gmail.com>
Subject: Re: [REGRESSION] [BISECTED] Unable to use 3D with Radeon 2100 and UI
 freezes with Firefox
From: =?UTF-8?Q?Rog=C3=A9rio_Brito?= <rbrito@ime.usp.br>
To: Dave Airlie <airlied@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Dave.

On Sat, Jul 30, 2011 at 05:10, Dave Airlie <airlied@gmail.com> wrote:
> On Sat, Jul 30, 2011 at 8:42 AM, Rogério Brito <rbrito@ime.usp.br> wrote:
>> It seems that the radeon thing is just one of the manifestations of the
>> problem.
>>
>> Today, I noticed another bad symptom, when I accidentally booted with kernel
>> 3.0 (I have many kernels in GRUB2): I printed a LaTeX document with only 2
>> pages of pure text.  My printer is an inkjet printer connected via USB to my
>> computer and it took about 6 minutes to print those 2 pages.
(...)
> Well I was hoping Thomas would help debug this, but he's gone on
> holidays, I'll try and take a look next week.
>
> but I've no real idea about the irq subsystem.

Thanks for the prompt reply. Should I file it on bugzilla? Just as a
reminder, the first problematic commit is
fa27271bc8d230355c1f24ddea103824fdc12de6: genirq: Fixup poll handling

As the MAINTAINERS file only lists Thomas as the responsible for the
IRQ subsystem, I'm still CC'ing linux-kernel, but I can bring the
discussion to any other mailing list, if applicable.


Thanks,
-- 
Rogério Brito : rbrito@{ime.usp.br,gmail.com} : GPG key 4096R/BCFCAAAA
http://rb.doesntexist.org : Packages for LaTeX : algorithms.berlios.de
DebianQA: http://qa.debian.org/developer.php?login=rbrito%40ime.usp.br
