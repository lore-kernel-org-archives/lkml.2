Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870Ab2K2Ob1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 09:31:27 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:40992 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754808Ab2K2Ob0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 09:31:26 -0500
MIME-Version: 1.0
In-Reply-To: <CAKgNAkhtTUAB82eBp5yABJL3ZfQ0=Q4y=CuJA-O98WYEHc2G0Q@mail.gmail.com>
References: <1336004953.4240.9.camel@mop> <CAHO5Pa2_D_L6wKPWccaYH2BYWYFc=4Khe0Om5GWU3D-tcAH0OQ@mail.gmail.com>
 <CAPXgP12jXOJzTTgwQkm7XK_ig2iEKAbhgNkF+MRR6_S49Tqx_A@mail.gmail.com>
 <CA+55aFxVyqScRU_c6RWVVub-tteuwjSq5JmThUtoxU-arBuh1w@mail.gmail.com>
 <CAPXgP11teRC8bFNzF2NHJ78Bj-jf0fgRz++5vjeHVEHY=+Xe+A@mail.gmail.com>
 <1354125084.20578.1.camel@nja> <CAKgNAkiFKPf44Q+X76TSGbR2LuyrFSWP7FLq_YdD8Twd2_25Ew@mail.gmail.com>
 <CAPXgP10OW_XuPMHn=KQzaESfpNhehkUx6=hKL2dHdGytZkGmng@mail.gmail.com>
 <CAKgNAkhQuugAOChSroXFgSPQ_=zyfFOZHzL3PGfU2SdmJcmj4w@mail.gmail.com>
 <CAPXgP11wq+u8JuBhOAYWKrwVp-c-aiJ18RgnghHPCMs-1MJWKg@mail.gmail.com> <CAKgNAkhtTUAB82eBp5yABJL3ZfQ0=Q4y=CuJA-O98WYEHc2G0Q@mail.gmail.com>
From: Kay Sievers <kay@vrfy.org>
Date: Thu, 29 Nov 2012 15:31:04 +0100
Message-ID: <CAPXgP122Wd3N1bEZSFt-rHxkNbAM2qr7R4G+09zZhU5viu3QQA@mail.gmail.com>
Subject: Re: [PATCH RESEND 1/3] printk: convert byte-buffer to variable-length
 record buffer
To: mtk.manpages@gmail.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartmann <greg@kroah.com>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 3:18 PM, Michael Kerrisk (man-pages)
<mtk.manpages@gmail.com> wrote:
> So, just to be clear: you better not apply your patch; it might break
> something ;-).

Sounds good to me. :)

Thanks,
Kay
