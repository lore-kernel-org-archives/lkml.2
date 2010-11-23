Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548Ab0KWPpN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 10:45:13 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:39381 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755164Ab0KWPpK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 10:45:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uwTNW61UHkbeVeXvF+/wCz3LyNUeUWACyZSQOfWQ8KNFEYqQ4h2vBVxeyGEA8lY5yp
         diVawJMFqTTZo+1pURNd0C9F+NOk27kliHjCnJefpmS3+8Gy6A4+3TGI/fdUAIiUTOyB
         e/LurTixF8H/Z/oolaJxGe5Wx63BlhLrFwr1c=
MIME-Version: 1.0
In-Reply-To: <20101123140609.2b6503ff.sfr@canb.auug.org.au>
References: <20101123140609.2b6503ff.sfr@canb.auug.org.au>
Date: Tue, 23 Nov 2010 16:45:09 +0100
Message-ID: <AANLkTikdCr--wvKCEa8YxOaCb8JaS=3d1GHTxLMtmw4t@mail.gmail.com>
Subject: Re: linux-next: Tree for November 23
From: Zimny Lech <napohybelskurwysynom2010@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Slawa,

2010/11/23 Stephen Rothwell <sfr@canb.auug.org.au>:
> Hi all,
>
> Changes since 20101122:

WARNING: modpost: Found 14 section mismatch(es).
To see full details build your kernel with:
'make CONFIG_DEBUG_SECTION_MISMATCH=y'
  GEN     .version
  CHK     include/generated/compile.h
  UPD     include/generated/compile.h
  CC      init/version.o
  LD      init/built-in.o
  LD      .tmp_vmlinux1
drivers/built-in.o: In function `timblogiw_close':
/home/test/linux-2.6/drivers/media/video/timblogiw.c:704: undefined
reference to `dma_release_channel'
drivers/built-in.o: In function `buffer_release':
/home/test/linux-2.6/drivers/media/video/timblogiw.c:595: undefined
reference to `dma_sync_wait'
drivers/built-in.o: In function `timblogiw_open':
/home/test/linux-2.6/drivers/media/video/timblogiw.c:671: undefined
reference to `__dma_request_channel'
make[1]: *** [.tmp_vmlinux1] Error 1
make: *** [sub-make] Error 2



-- 
Slawa!
N.P.S.

Chwa³a tobie, Szatanie, cze¶æ na wysoko¶ciach
Nieba, gdzie królowa³e¶, chwa³a w g³êboko¶ciach
Piek³a, gdzie zwyciê¿ony, trwasz w dumnym milczeniu!
Uczyñ, niechaj ma dusza spocznie z Tob± w cieniu
Drzewa Wiedzy, gdy swoje konary rozwinie,
Jak sklepienie ko¶cio³a, który nie przeminie!
