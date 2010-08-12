Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759842Ab0HLLEb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 07:04:31 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48662 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759755Ab0HLLE3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 07:04:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=f+MixJf2uZ/qfFvAZ9o5njTkC2BSmcIEr+JPjausc+Y7PN4k1/N0E/cNcK+Z0XxuvH
         A2G7toEpnCcl9R8OJCc6yVsB5FSZerTHvsG3vxG1NGXSpJ47P9tyNm4ZZYG8avhtPVVb
         /eUwnkOeKBUJA2wz8z+4gme6NNfv7cdKJDiZI=
From: Marek Vasut <marek.vasut@gmail.com>
Organization: Hack&Dev
To: Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [PATCH 1/2 v2] ARM: Fix gen_nand probe structures contents
Date: Thu, 12 Aug 2010 13:04:00 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.34-1-amd64; KDE/4.4.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux@arm.linux.org.uk, nico@fluxnic.net, kernel@wantstofly.org,
        kernel@pengutronix.de, u.kleine-koenig@pengutronix.de,
        kaloz@openwrt.org, khc@pm.waw.pl, tj@kernel.org, gregkh@suse.de,
        stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Artem.Bityutskiy@nokia.com, David.Woodhouse@intel.com,
        ralf@linux-mips.org, uclinux-dist-devel@blackfin.uclinux.org,
        yakovenkov@gmail.com, w.sang@pengutronix.de
References: <1281581635-26213-1-git-send-email-marek.vasut@gmail.com> <AANLkTimuLjGo7O1kWXq0XbTns4EV2e5q5o0esNns1BY9@mail.gmail.com>
In-Reply-To: <AANLkTimuLjGo7O1kWXq0XbTns4EV2e5q5o0esNns1BY9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201008121304.01178.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne Čt 12. srpna 2010 05:36:31 Mike Frysinger napsal(a):
> On Wed, Aug 11, 2010 at 22:53, Marek Vasut wrote:
> > These three platforms didn't properly fill nr_chips in gen_nand
> > registration and
> 
> > therefore depended on gen_nand bug fixed by the following patch:
> the Blackfin arch has a mailing list ... no need to pick out people

Hi, that's true, but there's that "scripts/get_maintainer.pl" thing which gave 
me this list.

Cheers
> 
> > "mtd: gen_nand: fix support for multiple chips"
> > 
> >  arch/blackfin/mach-bf537/boards/stamp.c   |    1 +
> >  arch/blackfin/mach-bf561/boards/acvilon.c |    1 +
> 
> looks sane enough to me
> Acked-by: Mike Frysinger <vapier@gentoo.org>
> -mike
