Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487Ab0KZHmD (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 26 Nov 2010 02:42:03 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:52736 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203Ab0KZHmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 02:42:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=l9y+vvxPBVW0XsGKh+qvXq37qNvo/wgeH96ceNaJt7WQa2KX3r93Z1Ojm/oz5SnInh
         b05f03KFdjAZtB80xFQDIRcGNKUz1Onn9zAtmcCZtOrHWT7n3pwFsiXWLu4uXQuhe+2D
         OrOQLxrCpyZhGKmunjeO+ysoUvAp3EFPTpLx4=
MIME-Version: 1.0
In-Reply-To: <20101126073805.GB14282@liondog.tnic>
References: <AANLkTinSigE4JPsFByPCkFd-+_oXQwR-V9=AsSH9Warz@mail.gmail.com>
	<1290755809.2678.14.camel@edumazet-laptop>
	<AANLkTi=8nWFHeJ0Z-WhprNqZMGprMRG5LQ+b3wKoMWWv@mail.gmail.com>
	<AANLkTi=bELgtgcWcy59KCvKwWWiuVZBb7e_hTSBHZ4cH@mail.gmail.com>
	<20101126073805.GB14282@liondog.tnic>
Date: Fri, 26 Nov 2010 08:41:59 +0100
Message-ID: <AANLkTikBgxBsGudfiN-xnN-KRNaanFrPpwOH_EMJ-oic@mail.gmail.com>
Subject: Re: Message
From: Alessandro Tagliapietra <tagliapietra.alessandro@gmail.com>
To: Borislav Petkov <bp@alien8.de>,
        Alessandro Tagliapietra <tagliapietra.alessandro@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        linux-ide <linux-ide@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/11/26 Borislav Petkov <bp@alien8.de>:
> adding linux-ide.

Thank you, i've also attached at this ubuntu bug:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/658521
the dmesg from ubuntu 10.10 and 11.04 with bios settings as RAID and AHCI.
I think that setting is only for Sata-2, as the drives are not seen by
the bios in the drive list. Just on the boot orded it see "IDE:
Marvell RAiD".
The drives are seen by the marvell controller after the bios, where
i've setup the raid 0 on them.

Best Regards

Alessandro Tagliapietra
