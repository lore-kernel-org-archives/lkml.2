Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442Ab0KZHiM (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 26 Nov 2010 02:38:12 -0500
Received: from mail.skyhub.de ([78.46.96.112]:42333 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750860Ab0KZHiK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 02:38:10 -0500
Date: Fri, 26 Nov 2010 08:38:05 +0100
From: Borislav Petkov <bp@alien8.de>
To: Alessandro Tagliapietra <tagliapietra.alessandro@gmail.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        linux-ide <linux-ide@vger.kernel.org>
Subject: Re: Message
Message-ID: <20101126073805.GB14282@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Alessandro Tagliapietra <tagliapietra.alessandro@gmail.com>,
	Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
	linux-ide <linux-ide@vger.kernel.org>
References: <AANLkTinSigE4JPsFByPCkFd-+_oXQwR-V9=AsSH9Warz@mail.gmail.com>
 <1290755809.2678.14.camel@edumazet-laptop>
 <AANLkTi=8nWFHeJ0Z-WhprNqZMGprMRG5LQ+b3wKoMWWv@mail.gmail.com>
 <AANLkTi=bELgtgcWcy59KCvKwWWiuVZBb7e_hTSBHZ4cH@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=bELgtgcWcy59KCvKwWWiuVZBb7e_hTSBHZ4cH@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

adding linux-ide.

On Fri, Nov 26, 2010 at 08:35:48AM +0100, Alessandro Tagliapietra wrote:
> Venerdì 26 novembre 2010 alle 08:16 +0100, Eric Dumazet ha scritto:
> > Thanksgiving might be the reason.
> 
> No problem :)
> I've this problem (that i think also affect some people and probably
> more in the future)
> 
> I've a asus p6x58d-e motherboard with a Marver 9128 (1b4b:91a3) Sata-6
> controller. I've tried both ubuntu and fedora (that has newer kernel)
> and both can't find the 2 western digital sata-6 drives configured in
> raid0.
> 
> I've looked here
> https://ata.wiki.kernel.org/index.php/SATA_hardware_features and the
> Marvell	88SE9128/9120/9125/9111/9110 seems that they haven't any
> driver right?
> 
> I'm new to the kernel mailing list, what are the next steps to help?
> 
> Best regards
> 
> Alessandro Tagliapietra
> 
> Sorry for double mail Eric but i haven't sent it on list.
> --

-- 
Regards/Gruss,
    Boris.
