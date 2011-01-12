Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754963Ab1ALPkV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 10:40:21 -0500
Received: from casper.infradead.org ([85.118.1.10]:42152 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276Ab1ALPkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 10:40:19 -0500
Date: Wed, 12 Jan 2011 15:40:16 +0000 (GMT)
From: James Simmons <jsimmons@infradead.org>
To: Anca Emanuel <anca.emanuel@gmail.com>
cc: Christian Borntraeger <borntraeger@de.ibm.com>,
        Dave Airlie <airlied@linux.ie>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] drm for rc1
In-Reply-To: <AANLkTik=HYzW8--_W+qxi8S9QbAkf9ZZy=uLyaTeV+PC@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1101121538470.8212@casper.infradead.org>
References: <alpine.DEB.2.00.1101102250090.15019@skynet.skynet.ie> <4D2CE5C8.60601@de.ibm.com> <AANLkTimr4WX3Ay8vC23MKOM+dOcpV+Ca5rg_gcei38nk@mail.gmail.com> <4D2D8ED0.6080807@de.ibm.com> <AANLkTik4h=4o8JEwfd+=CFVb4NgkwaEwxmM6n_+sDj3K@mail.gmail.com>
 <alpine.LFD.2.00.1101121344070.8212@casper.infradead.org> <AANLkTimdnYHWfBE1nB+2EDRouO7_FoRByVboMYw8WaHB@mail.gmail.com> <AANLkTik=HYzW8--_W+qxi8S9QbAkf9ZZy=uLyaTeV+PC@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> >>> I tested the revert: the boot screen did change the resolution
> >>> (without it don't), but my PC still hangs. (using an nvidia 8800GT).
> >>
> >> Try my most recent patch. Where does it hang at? Any logs?
> >>
> >
> > With your patch, I can boot the system. But nouveau is not loaded.
> > dmesg attached.
> >
> 
> Forget to mention: the revert makes first steps of boot look the same
> (change the resolution of the text)
> but with your patch, I see a big ugly ununtu logo, (I think that is
> because nouveau is not loaded)

Is nouveau a module? Does X run? From my understanding is the xorg driver 
need KMS to run. I didn't see nouveau at all in your dmesg.

