Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932083Ab0JUNVb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 09:21:31 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:60129 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757556Ab0JUNVa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 09:21:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JYaE3xIkKlP4M3QCiBXIxeWVqwGdTOYk1j0NGIf4kO6+gi7QXMFBTa38uH1/ofwwhL
         QupiF81NefIYjTPRq1CwcfevpB4VQHYkuvi8AWpbiGRat5Nut712Iv0+BXNCfHR+Cpnh
         9edqrM8xWlCd88IKGjqjWJudKI8LfOIGTGHeg=
MIME-Version: 1.0
In-Reply-To: <20101021130925.GA32548@infradead.org>
References: <20101020162053.5595e1bf.sfr@canb.auug.org.au>
	<20101021130925.GA32548@infradead.org>
Date: Thu, 21 Oct 2010 15:21:29 +0200
Message-ID: <AANLkTimSXeA3=ewP29H5TM2nR3TEWTVzyS1fi1KST3Ws@mail.gmail.com>
Subject: Re: linux-next: Tree for October 20
From: Zimny Lech <napohybelskurwysynom2010@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, mmarek@suse.cz
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I had a similar problem, mrproper solved it

2010/10/21 Christoph Hellwig <hch@infradead.org>:
> I can't even get the required userspace code make oldconfig to compile:
>
> hch@brick:~/work/linux-2.6/obj-kvm$ make oldconfig
> make -C /home/hch/work/linux-2.6 O=/home/hch/work/linux-2.6/obj-kvm/. oldconfig
>  GEN     /home/hch/work/linux-2.6/obj-kvm/Makefile
>  HOSTCC  scripts/kconfig/zconf.tab.o
> In file included from scripts/kconfig/zconf.tab.c:2481:
> scripts/kconfig/lex.zconf.c:2425: error: conflicting types for 'zconf_curname'
> /home/hch/work/linux-2.6/scripts/kconfig/lkc.h:79: note: previous declaration of 'zconf_curname' was here
> scripts/kconfig/lex.zconf.c: In function 'zconf_curname':
> scripts/kconfig/lex.zconf.c:2427: warning: return discards qualifiers from pointer target type
>
> I'm compiling on 32-bit x86, using:
>
> gcc version 4.4.5 20100728 (prerelease) (Debian 4.4.4-8)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Slawa!
N.P.S.

Les fleurs du mal unfold
Comme les fleurs du mal
Dark demons of my soul
Un amour fatal
