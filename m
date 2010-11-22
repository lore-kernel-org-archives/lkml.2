Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756946Ab0KVTq7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 14:46:59 -0500
Received: from cantor.suse.de ([195.135.220.2]:56052 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755750Ab0KVTq5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 14:46:57 -0500
Date: Mon, 22 Nov 2010 11:46:43 -0800
From: Greg KH <gregkh@suse.de>
To: Zimny Lech <napohybelskurwysynom2010@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Brett Rudley <brudley@broadcom.com>,
        Henry Ptasinski <henryp@broadcom.com>, linux-wireless@vger.kernel.org
Subject: Re: linux-next: Tree for November 22
Message-ID: <20101122194643.GB21985@suse.de>
References: <20101122134911.b7e106f9.sfr@canb.auug.org.au>
 <AANLkTi=QeU_vb6+XRei0pqz7GSfp2E4TC3oTJYy9adv4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=QeU_vb6+XRei0pqz7GSfp2E4TC3oTJYy9adv4@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 22, 2010 at 04:37:57PM +0100, Zimny Lech wrote:
> Salve
> 
> 2010/11/22 Stephen Rothwell <sfr@canb.auug.org.au>:
> > Hi all,
> >
> > Changes since 20101119:
> >
> 
> 
>   CC [M]  drivers/staging/brcm80211/brcmfmac/wl_iw.o
> /home/test/linux-2.6/drivers/staging/brcm80211/brcmfmac/wl_iw.c:130:19:
> error: field 'sysioc_sem' has incomplete type
> /home/test/linux-2.6/drivers/staging/brcm80211/brcmfmac/wl_iw.c: In
> function 'wl_iw_timerfunc':
> /home/test/linux-2.6/drivers/staging/brcm80211/brcmfmac/wl_iw.c:1070:4:
> error: implicit declaration of function 'up'
> /home/test/linux-2.6/drivers/staging/brcm80211/brcmfmac/wl_iw.c: In
> function '_iscan_sysioc_thread':
> /home/test/linux-2.6/drivers/staging/brcm80211/brcmfmac/wl_iw.c:1181:2:
> error: implicit declaration of function 'down_interruptible'
> /home/test/linux-2.6/drivers/staging/brcm80211/brcmfmac/wl_iw.c: In
> function 'wl_iw_attach':
> /home/test/linux-2.6/drivers/staging/brcm80211/brcmfmac/wl_iw.c:3708:2:
> error: implicit declaration of function 'sema_init'
> make[5]: *** [drivers/staging/brcm80211/brcmfmac/wl_iw.o] Error 1
> make[4]: *** [drivers/staging/brcm80211/brcmfmac] Error 2
> make[3]: *** [drivers/staging/brcm80211] Error 2
> make[2]: *** [drivers/staging] Error 2
> make[1]: *** [drivers] Error 2
> make: *** [sub-make] Error 2
> 

Ick, not good.

Henry, Brett, any ideas?

thanks,

greg k-h
