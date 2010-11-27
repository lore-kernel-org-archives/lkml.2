Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573Ab0K0VyP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 16:54:15 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:50705 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749Ab0K0VyJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 16:54:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fCqVlasjQcqxEYlO09LJmJA1sDPJkc/L/gNez68Sk+x/fHCK7WX5YrjfWJi3S0GYc9
         Oak0uItI3dRub2XvZj8b5uGUy7EdrHEmO40zgdou0QkMkg7ScRnsfKUpBGqA3Env/VnW
         1q8EDM52qhBJAEj4i+rito1lg9fN/Cf0iNb44=
MIME-Version: 1.0
In-Reply-To: <20101126132823.7ef94f07.sfr@canb.auug.org.au>
References: <20101126132823.7ef94f07.sfr@canb.auug.org.au>
Date: Sat, 27 Nov 2010 22:54:08 +0100
Message-ID: <AANLkTim1=OijO4f0rk4W=2h1CW_xX27tSbDj8s9af7Xw@mail.gmail.com>
Subject: Re: linux-next: Tree for November 26
From: Zimny Lech <napohybelskurwysynom2010@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Salve!

2010/11/26 Stephen Rothwell <sfr@canb.auug.org.au>:
> Hi all,
>
> Changes since 20101125:
>

just a reminder - these errors still occur:

WARNING: modpost: Found 10 section mismatch(es).
To see full details build your kernel with:
'make CONFIG_DEBUG_SECTION_MISMATCH=y'
  GEN     .version
  CHK     include/generated/compile.h
  UPD     include/generated/compile.h
  CC      init/version.o
  LD      init/built-in.o
  LD      .tmp_vmlinux1
arch/x86/built-in.o: In function `kvm_smp_prepare_boot_cpu':
kvm.c:(.init.text+0xe543): undefined reference to `kvm_register_clock'
make[1]: *** [.tmp_vmlinux1] Error 1
make: *** [sub-make] Error 2

make[4]: *** No rule to make target
`drivers/scsi/aic7xxx/aicasm/*.[chyl]', needed by
`drivers/scsi/aic7xxx/aicasm/aicasm'.  Stop.
make[3]: *** [drivers/scsi/aic7xxx] Error 2
make[2]: *** [drivers/scsi] Error 2
make[1]: *** [drivers] Error 2
make: *** [sub-make] Error 2


  CC      sound/oss/aedsp16.o
make[3]: *** No rule to make target `/etc/sound/dsp001.ld', needed by
`sound/oss/pss_boot.h'.  Stop.
make[2]: *** [sound/oss] Error 2
make[1]: *** [sound] Error 2
make: *** [sub-make] Error 2

  CC [M]  drivers/block/cciss.o
/home/test/linux-2.6/drivers/block/cciss.c: In function 'cciss_cleanup':
/home/test/linux-2.6/drivers/block/cciss.c:4929:6: error: 'proc_cciss'
undeclared (first use in this function)
/home/test/linux-2.6/drivers/block/cciss.c:4929:6: note: each
undeclared identifier is reported only once for each function it
appears in
make[3]: *** [drivers/block/cciss.o] Error 1
make[2]: *** [drivers/block] Error 2
make[1]: *** [drivers] Error 2
make: *** [sub-make] Error 2




-- 
Slawa!
Zimny "¯yj i pozwól umrzeæ" Lech z Wawelu

That is not dead which can eternal lie.
And with strange aeons even death may die.
