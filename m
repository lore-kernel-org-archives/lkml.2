Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933327Ab0LTXle (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 18:41:34 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59607 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933273Ab0LTXld convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 18:41:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DuM01IsvOVQDPiNlNT+QPH4tlclPXO2YckqOjY5LkaANR6nM25VT4a8ZBDqrGhswPU
         e5w8FASXOOkW9JndI1/E8TLMxn14lNogpurpqexJQVHTvdqPF+85+hVSx5LWxInYdYTO
         G30U9uASh2vbhsZ5IX2yaccYqrwd1KJPnYPpw=
MIME-Version: 1.0
In-Reply-To: <20101220233002.GA1760@Pilar.aei.mpg.de>
References: <20101220172228.GA463@Pilar.aei.mpg.de>
	<AANLkTi=3WHB6iKaM5-=z33b9Nux7WyQ2K0apuRNwMhD=@mail.gmail.com>
	<20101220233002.GA1760@Pilar.aei.mpg.de>
Date: Mon, 20 Dec 2010 18:41:32 -0500
Message-ID: <AANLkTikvTL6SB0b6r2DQTUU5yu_9j4SUgmmjMiVmgamD@mail.gmail.com>
Subject: Re: Build regression: unknown option "visible"
From: Arnaud Lacombe <lacombar@gmail.com>
To: "Carlos R. Mafra" <crmafra2@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Michal Marek <mmarek@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Dec 20, 2010 at 6:30 PM, Carlos R. Mafra <crmafra2@gmail.com> wrote:
> On Mo 20.Dez'10 at 12:37:26 -0500, Arnaud Lacombe wrote:
>> Hi,
>>
>> On Mon, Dec 20, 2010 at 12:22 PM, Carlos R. Mafra <crmafra2@gmail.com> wrote:
>> > After pulling latest git from Linus (v2.6.37-rc6-132-g55ec86f)
>> > I can't compile it anymore:
>> >
>> > [mafra@Pilar:linux-2.6]$ make -j2 O=/mnt/ext4/kernel-output/
>> >  GEN     /mnt/ext4/kernel-output/Makefile
>> > scripts/kconfig/conf --silentoldconfig Kconfig
>> > drivers/i2c/algos/Kconfig:6: unknown option "visible"
>> > drivers/media/common/tuners/Kconfig:48: unknown option "visible"
>> > drivers/media/video/Kconfig:115: unknown option "visible"
>> > drivers/media/dvb/frontends/Kconfig:16: unknown option "visible"
>> > make[3]: *** [silentoldconfig] Fehler 1
>> > make[2]: *** [silentoldconfig] Fehler 2
>> >
>> > This was introduced by 37e3273ee52f ("media/video: convert Kconfig
>> > to use the menu's `visible' keyword"), but I did a quick search
>> > and apparently I am the only one with a broken build.
>> >
>> > In any case, that's a regression for me and therefore I'm reporting it.
>> >
>> > I can test patches etc and provide more info if needed.
>> >
>> Did you build from a clean tree or a dirty one ?
>
> It was the same one which I always compile after pulling.
> So there is compiled stuff in the build dir /mnt/ext4/kernel-output
> (in an external hd).
>
>> I know these is issue with Kbuild where the parser will not get
>> updated to the new version if the target already exist but is older
>> than the current "shipped" one.
>
> Hm, not sure what this means. Should I do a 'make clean' to get it
> back working?
>
yes.

 - Arnaud
