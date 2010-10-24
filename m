Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932534Ab0JXLdO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 07:33:14 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:48806 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932448Ab0JXLdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 07:33:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=CRLZbATEdgnb4BkieZB862UvTOQxJREdmmWw4o7PZzE93KfLC2WLnjpkWf7SByG+/U
         gIrI6r7hXH9telEYzpFqoscXO3FgHTWlK0h9Fi/DOIW6/4YsXCfgQDu9da8Nfx85dZL6
         x2eRrofnHi3YXmGRspLaLyA+XoseS3YFqb8Ow=
MIME-Version: 1.0
In-Reply-To: <201010230008.o9N08f3E015576@imap1.linux-foundation.org>
References: <201010230008.o9N08f3E015576@imap1.linux-foundation.org>
Date: Sun, 24 Oct 2010 13:33:12 +0200
Message-ID: <AANLkTikYgne8_2O0qmA4zKjZfv3gvfrXTsr-GjsZypc=@mail.gmail.com>
Subject: Re: mmotm 2010-10-22-16-36 uploaded
From: Zimny Lech <napohybelskurwysynom2010@gmail.com>
To: akpm@linux-foundation.org
Cc: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/10/23  <akpm@linux-foundation.org>:
> The mm-of-the-moment snapshot 2010-10-22-16-36 has been uploaded to

I think I reported this before

  CC      drivers/scsi/scsi_transport_sas.o
make[4]: *** No rule to make target
`drivers/scsi/aic7xxx/aicasm/*.[chyl]', needed by
`drivers/scsi/aic7xxx/aicasm/aicasm'.  Stop.
make[3]: *** [drivers/scsi/aic7xxx] Error 2
make[2]: *** [drivers/scsi] Error 2
make[1]: *** [drivers] Error 2
make: *** [sub-make] Error 2

This one is new to me

  CC [M]  drivers/staging/brcm80211/brcmfmac/wl_iw.o
/home/test/linux-2.6-mm/drivers/staging/brcm80211/brcmfmac/wl_iw.c:130:19:
error: field 'sysioc_sem' has incomplete type
/home/test/linux-2.6-mm/drivers/staging/brcm80211/brcmfmac/wl_iw.c: In
function 'wl_iw_timerfunc':
/home/test/linux-2.6-mm/drivers/staging/brcm80211/brcmfmac/wl_iw.c:1070:4:
error: implicit declaration of function 'up'
/home/test/linux-2.6-mm/drivers/staging/brcm80211/brcmfmac/wl_iw.c: In
function '_iscan_sysioc_thread':
/home/test/linux-2.6-mm/drivers/staging/brcm80211/brcmfmac/wl_iw.c:1181:2:
error: implicit declaration of function 'down_interruptible'
/home/test/linux-2.6-mm/drivers/staging/brcm80211/brcmfmac/wl_iw.c: In
function 'wl_iw_attach':
/home/test/linux-2.6-mm/drivers/staging/brcm80211/brcmfmac/wl_iw.c:3709:2:
error: implicit declaration of function 'sema_init'
make[5]: *** [drivers/staging/brcm80211/brcmfmac/wl_iw.o] Error 1
make[4]: *** [drivers/staging/brcm80211/brcmfmac] Error 2
make[3]: *** [drivers/staging/brcm80211] Error 2
make[2]: *** [drivers/staging] Error 2
make[1]: *** [drivers] Error 2
make: *** [sub-make] Error 2


-- 
Slawa!
N.P.S.

Les fleurs du mal unfold
Comme les fleurs du mal
Dark demons of my soul
Un amour fatal
