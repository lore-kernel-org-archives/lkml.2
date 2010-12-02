Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757609Ab0LBNw7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 08:52:59 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:62211 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757552Ab0LBNw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 08:52:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=RTc8tMzZxCxwwBgyRqsqjPhlsXl5GBjEIwJn/iBlZTJuNQNO/uvJeH4b2nRGghvKKd
         wDQ2j3xs6VqiYRSjnrbAkdERXDFoPSVPF3u7xyWoTvdjEETT70e/3Qx9pnDEYqj3YgJd
         ZmtPOPI3iqc+zOQvLSaaAPeyp48OV9epqtWSw=
MIME-Version: 1.0
In-Reply-To: <20101202140943.c9742beb.sfr@canb.auug.org.au>
References: <20101202140943.c9742beb.sfr@canb.auug.org.au>
Date: Thu, 2 Dec 2010 14:52:56 +0100
Message-ID: <AANLkTi=aZ3Gm5rkqAh8j-bOvvKULge6Hm5cN_mEovVdq@mail.gmail.com>
Subject: Re: linux-next: Tree for December 2
From: Zimny Lech <napohybelskurwysynom2010@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ave

2010/12/2 Stephen Rothwell <sfr@canb.auug.org.au>:
> Hi all,
>
> Changes since 20101201:
>

WARNING: modpost: Found 4 section mismatch(es).
To see full details build your kernel with:
'make CONFIG_DEBUG_SECTION_MISMATCH=y'
  GEN     .version
  CHK     include/generated/compile.h
  UPD     include/generated/compile.h
  CC      init/version.o
  LD      init/built-in.o
  LD      .tmp_vmlinux1
drivers/built-in.o: In function `pch_request_dma':
/home/test/linux-2.6/drivers/serial/pch_uart.c:565: undefined
reference to `__dma_request_channel'
/home/test/linux-2.6/drivers/serial/pch_uart.c:577: undefined
reference to `__dma_request_channel'
/home/test/linux-2.6/drivers/serial/pch_uart.c:580: undefined
reference to `dma_release_channel'
drivers/built-in.o: In function `pch_free_dma':
/home/test/linux-2.6/drivers/serial/pch_uart.c:519: undefined
reference to `dma_release_channel'
/home/test/linux-2.6/drivers/serial/pch_uart.c:523: undefined
reference to `dma_release_channel'
make[1]: *** [.tmp_vmlinux1] Error 1
make: *** [sub-make] Error 2


-- 
Slawa!
Zimny "Spie dziadu!" Lech z Wawelu

That is not dead which can eternal lie.
And with strange aeons even death may die.
