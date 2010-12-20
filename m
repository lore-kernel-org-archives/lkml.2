Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757773Ab0LTRh2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 12:37:28 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58738 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757644Ab0LTRh1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 12:37:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=iPRYoteEVHNjBTyLXSwmKkvNfqZTxmwCY04+P6SGdmQ24neaXI6hW9RSwa/5qYJ6k3
         3kqLjoviCJTF12t2i4BImpXBuK87YKrbhPbDSUclw9KmYNfSJOm9v5FYILkoky68WNOn
         mgwbUTZ1iW/IDUFbm0bykOWA93zxl6/9ziars=
MIME-Version: 1.0
In-Reply-To: <20101220172228.GA463@Pilar.aei.mpg.de>
References: <20101220172228.GA463@Pilar.aei.mpg.de>
Date: Mon, 20 Dec 2010 12:37:26 -0500
Message-ID: <AANLkTi=3WHB6iKaM5-=z33b9Nux7WyQ2K0apuRNwMhD=@mail.gmail.com>
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

On Mon, Dec 20, 2010 at 12:22 PM, Carlos R. Mafra <crmafra2@gmail.com> wrote:
> After pulling latest git from Linus (v2.6.37-rc6-132-g55ec86f)
> I can't compile it anymore:
>
> [mafra@Pilar:linux-2.6]$ make -j2 O=/mnt/ext4/kernel-output/
>  GEN     /mnt/ext4/kernel-output/Makefile
> scripts/kconfig/conf --silentoldconfig Kconfig
> drivers/i2c/algos/Kconfig:6: unknown option "visible"
> drivers/media/common/tuners/Kconfig:48: unknown option "visible"
> drivers/media/video/Kconfig:115: unknown option "visible"
> drivers/media/dvb/frontends/Kconfig:16: unknown option "visible"
> make[3]: *** [silentoldconfig] Fehler 1
> make[2]: *** [silentoldconfig] Fehler 2
>
> This was introduced by 37e3273ee52f ("media/video: convert Kconfig
> to use the menu's `visible' keyword"), but I did a quick search
> and apparently I am the only one with a broken build.
>
> In any case, that's a regression for me and therefore I'm reporting it.
>
> I can test patches etc and provide more info if needed.
>
Did you build from a clean tree or a dirty one ?

I know these is issue with Kbuild where the parser will not get
updated to the new version if the target already exist but is older
than the current "shipped" one.

 - Arnaud
