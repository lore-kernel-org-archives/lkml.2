Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323Ab0LCVn2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 16:43:28 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:40765 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902Ab0LCVn1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 16:43:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rSiikH2AlUc2cXCe/fQp5kOGRKyieB1Z2gK/olo2hqrK1gzDtZLVTWckyLeUQlgcpI
         7Ax9pLHi1m3GOx7/L1BLSFkZ7cakzxNEftPwN6ih0BHFrKw3m/rFRCJ3gbQ8G0sCpC8W
         J/lD/llo16+OEpmCh/84ZgjaxiOF6p1l+87os=
MIME-Version: 1.0
In-Reply-To: <201012030107.oB317ZSW019223@imap1.linux-foundation.org>
References: <201012030107.oB317ZSW019223@imap1.linux-foundation.org>
Date: Fri, 3 Dec 2010 22:43:25 +0100
Message-ID: <AANLkTik3uaOV5U8H30p9AyFsa_HzVMsyqdhxhGBFhxMP@mail.gmail.com>
Subject: Re: mmotm 2010-12-02-16-34 uploaded
From: Zimny Lech <napohybelskurwysynom2010@gmail.com>
To: akpm@linux-foundation.org
Cc: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ave,

2010/12/3  <akpm@linux-foundation.org>:
> The mm-of-the-moment snapshot 2010-12-02-16-34 has been uploaded to
>

23 builds, and only known problems, nothing new

arch/x86/built-in.o: In function `kvm_smp_prepare_boot_cpu':
kvm.c:(.init.text+0xdb49): undefined reference to `kvm_register_clock'
make[1]: *** [.tmp_vmlinux1] Error 1
make: *** [sub-make] Error 2

drivers/built-in.o: In function `pch_uart_shutdown':
pch_uart.c:(.text+0x1a9921): undefined reference to `dma_release_channel'
pch_uart.c:(.text+0x1a9939): undefined reference to `dma_release_channel'
drivers/built-in.o: In function `pch_uart_startup':
pch_uart.c:(.text+0x1a9bdd): undefined reference to `__dma_request_channel'
pch_uart.c:(.text+0x1a9c3e): undefined reference to `__dma_request_channel'
pch_uart.c:(.text+0x1a9e38): undefined reference to `dma_release_channel'
make[1]: *** [.tmp_vmlinux1] Error 1
make: *** [sub-make] Error 2

make[4]: *** No rule to make target
`drivers/scsi/aic7xxx/aicasm/*.[chyl]', needed by
`drivers/scsi/aic7xxx/aicasm/aicasm'.  Stop.
make[3]: *** [drivers/scsi/aic7xxx] Error 2
make[2]: *** [drivers/scsi] Error 2
make[1]: *** [drivers] Error 2
make: *** [sub-make] Error 2




-- 
Slawa!
Zimny "Spie dziadu!" Lech z Wawelu

Piekielny strach zagrzmia³
Patrzê na sufit
Krew tam
Strzêpy g³ów w bólach jêcz± co¶
