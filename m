Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933322Ab0LTXjJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 18:39:09 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:60511 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932252Ab0LTXjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 18:39:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=GiSH3KyRNUzhtytYQ1Y+AJyif8gA9p5wkqvBU4P32n2ELJdcaspR9slQ9K2rWfxx4O
         AK2rUNuzef669LijsgftKYOUWYtqtaZwLO0sZANLXVwFxDMTLfA/5KMKW1ftoADLn1yE
         Ya3Ptj1RBEiLZ5oLcZ7Uqb+XXVj+z6CVx5XM4=
Date: Tue, 21 Dec 2010 00:30:02 +0100
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Michal Marek <mmarek@suse.cz>
Subject: Re: Build regression: unknown option "visible"
Message-ID: <20101220233002.GA1760@Pilar.aei.mpg.de>
References: <20101220172228.GA463@Pilar.aei.mpg.de>
 <AANLkTi=3WHB6iKaM5-=z33b9Nux7WyQ2K0apuRNwMhD=@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=3WHB6iKaM5-=z33b9Nux7WyQ2K0apuRNwMhD=@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mo 20.Dez'10 at 12:37:26 -0500, Arnaud Lacombe wrote:
> Hi,
> 
> On Mon, Dec 20, 2010 at 12:22 PM, Carlos R. Mafra <crmafra2@gmail.com> wrote:
> > After pulling latest git from Linus (v2.6.37-rc6-132-g55ec86f)
> > I can't compile it anymore:
> >
> > [mafra@Pilar:linux-2.6]$ make -j2 O=/mnt/ext4/kernel-output/
> >  GEN     /mnt/ext4/kernel-output/Makefile
> > scripts/kconfig/conf --silentoldconfig Kconfig
> > drivers/i2c/algos/Kconfig:6: unknown option "visible"
> > drivers/media/common/tuners/Kconfig:48: unknown option "visible"
> > drivers/media/video/Kconfig:115: unknown option "visible"
> > drivers/media/dvb/frontends/Kconfig:16: unknown option "visible"
> > make[3]: *** [silentoldconfig] Fehler 1
> > make[2]: *** [silentoldconfig] Fehler 2
> >
> > This was introduced by 37e3273ee52f ("media/video: convert Kconfig
> > to use the menu's `visible' keyword"), but I did a quick search
> > and apparently I am the only one with a broken build.
> >
> > In any case, that's a regression for me and therefore I'm reporting it.
> >
> > I can test patches etc and provide more info if needed.
> >
> Did you build from a clean tree or a dirty one ?

It was the same one which I always compile after pulling. 
So there is compiled stuff in the build dir /mnt/ext4/kernel-output
(in an external hd).
 
> I know these is issue with Kbuild where the parser will not get
> updated to the new version if the target already exist but is older
> than the current "shipped" one.

Hm, not sure what this means. Should I do a 'make clean' to get it
back working?
