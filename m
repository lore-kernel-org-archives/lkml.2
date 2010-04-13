Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753066Ab0DMPgq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 11:36:46 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:36009 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165Ab0DMPgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 11:36:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=W8KjZWSAHPf7HG4TbeThkmtIrIdxwxJ3mnx9/T/pp6poaXpM8/e7pTSM7nckC2mEBB
         Ld0MFlQBpFbeSU3ycim3eF++arLT85ope+i/f/pDZp57c8jZD7xtCEW2Kff+bm3rhttk
         AjPD6eY69KMxmxo0VMtRId/I0pfQbPoE0uFyk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Subject: Re: linux-ide: hda: possibly failed opcode: 0x25 on Alpha with 2.6.34-rc3
Date: Tue, 13 Apr 2010 17:34:57 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.33-0.1-desktop; KDE/4.3.5; x86_64; ; )
Cc: "David S. Miller" <davem@davemloft.net>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Alan Cox <alan@linux.intel.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20100406232659.GA4788@physik.fu-berlin.de>
In-Reply-To: <20100406232659.GA4788@physik.fu-berlin.de>
MIME-Version: 1.0
Message-Id: <201004131734.57365.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 April 2010 01:26:59 am Adrian Glaubitz wrote:
> Dear IDE maintainers,

I'm flattered but nowadays I'm just a maintainer of a modest
out-of-tree project or two.. ;-)

> I recently installed Debian unstable on an old digital personal
> workstation 433au alpha (Miata) [1] with the default kernel 2.6.32
> from Debian unstable. There were no obvious problems except for the
> tulip network driver which produced a lot of noise [2]. Joe Perches was
> so kind to provide a patch to reduce the noise. I applied the patch
> against 2.6.34-rc3 and rebuilt the kernel with the 2.6.32 Debian
> config using "make oldconfig". The kernel build took around 18 hours ;).
> 
> Anyway, after rebooting the machine into the new kernel (2.6.34-rc3), the
> IDE driver obviously triggered a lot of errors [3] resulting in the kernel
> not being able to mount the root partition.

I think that the highest chance of bringing the right people's
attention to this kernel regression would be achieved by filling
the official bug-report at https://bugzilla.kernel.org/.

Thanks.
--
Bartlomiej Zolnierkiewicz
