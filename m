Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283Ab0KXN4I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 08:56:08 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:50107 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754769Ab0KXN4G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 08:56:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Rmgpil6ACIkJO7dPZkHwx7VCzAuD8T+lZyamX6wP4FvxDucYTOWNRP6SOvxK12bheY
         eyO0IG4XkZ9kxToAKY5a6jmajfdfBWcmwNHk/OpDaYyPOMV1DR4meWTsQevu/6jvGAAt
         0x/ZDZNs6Ci2hG1bZMeolKzXw3jsoo6DNTXh4=
MIME-Version: 1.0
In-Reply-To: <201011240045.oAO0jYQ5016010@imap1.linux-foundation.org>
References: <201011240045.oAO0jYQ5016010@imap1.linux-foundation.org>
Date: Wed, 24 Nov 2010 14:56:04 +0100
Message-ID: <AANLkTi=GvVx76w=kbC_E1wunAe3VSYZDEopMH27aoBX5@mail.gmail.com>
Subject: Re: mmotm 2010-11-23-16-12 uploaded
From: Zimny Lech <napohybelskurwysynom2010@gmail.com>
To: akpm@linux-foundation.org
Cc: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ave

2010/11/24  <akpm@linux-foundation.org>:
> The mm-of-the-moment snapshot 2010-11-23-16-12 has been uploaded to

So far, so good - eight builds and one error (AFAICS known issue)

'make CONFIG_DEBUG_SECTION_MISMATCH=y'
  GEN     .version
  CHK     include/generated/compile.h
  UPD     include/generated/compile.h
  CC      init/version.o
  LD      init/built-in.o
  LD      .tmp_vmlinux1
drivers/built-in.o: In function `timblogiw_close':
/home/test/linux-2.6-mm/drivers/media/video/timblogiw.c:704: undefined
reference to `dma_release_channel'
drivers/built-in.o: In function `buffer_release':
/home/test/linux-2.6-mm/drivers/media/video/timblogiw.c:595: undefined
reference to `dma_sync_wait'
drivers/built-in.o: In function `timblogiw_open':
/home/test/linux-2.6-mm/drivers/media/video/timblogiw.c:671: undefined
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
