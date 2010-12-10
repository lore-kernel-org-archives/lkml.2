Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846Ab0LJIr5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 03:47:57 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:51875 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207Ab0LJIr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 03:47:56 -0500
Date: Fri, 10 Dec 2010 09:44:00 +0100
From: Christian Glindkamp <christian.glindkamp@taskit.de>
To: Igor Plyatov <plyatov@gmail.com>
Cc: Ryan Mallon <ryan@bluewatersys.com>, linux@arm.linux.org.uk,
        Nicolas Ferre <nicolas.ferre@atmel.com>, costa.antonior@gmail.com,
        linux@maxim.org.za, linux-arm-kernel@lists.infradead.org,
        plagnioj@jcrosoft.com, pgsellmann@portner-elektronik.at,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] at91: Refactor Stamp9G20 and PControl G20 board file
Message-ID: <20101210084400.GA24295@taskit.de>
References: <4CFFE5A9.4040407@bluewatersys.com>
 <1291889759-12281-1-git-send-email-christian.glindkamp@taskit.de>
 <1291909193.6251.32.camel@homepc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291909193.6251.32.camel@homepc>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:uNZIRKiwkHDs+Ej+NQyJtyjJ7/NhnNefQJTTcY0WhzF
 O/txwe6EeC4kN0bGLM3+JQ3rVwg3beZ/2e4r65264FZFs4G0fH
 oZXhr1258k/8JRmuS+3REfzGuntrqHcocZ0BrbUOcG5waq17nZ
 X62guP5LAZ0qckUEVY7zkadnvvH75T6MskNBhteEyeBuk3xxYV
 kbLvT31cj7RMQB9TH8VXw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-12-09 18:39, Igor Plyatov wrote:
> Dear Christian,
> 
> > As PControl G20 is a carrier board for the Stamp9G20 SoM, some code can
> > be shared. Therefore board-stamp9g20.c is refactored to allow reusing the
> > SoM initialization and board-pcontrol-g20.c is modified to use it.
> > 
> > Signed-off-by: Christian Glindkamp <christian.glindkamp@taskit.de>
> > ---
> > 
> > How about this approach? Compile tested for PControl G20 and run time tested
> > for Stamp9G20 EVB and PortuxG20.
> > 
> > Just a side note: PortuxG20 is not a carrier board for the Stamp9G20. It just
> > shares so much with the evaluation board, that it makes sense to put them both
> > into the same file. And there is no intention to put other boards into this
> > file.
> 
> The idea from this patch is clean.
> Yours patch does not apply to the kernel from
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git,
> but I apply its content by hands and kernels compiled successfully with
> stamp9g20_defconfig and pcontrol_g20_defconfig.

I used exactly this repository. Revision 6313e3c21743cc88bb5bd8aa72948ee1e83937b6
to be precise. Maybe your mailer corrupted the patch.

> Please run ./scripts/checkpatch.pl with you patch and correct all errors
> and warnings reported. 

I only get some "line over 80 characters" warnings, which can imho be
ignored.

> 
> If you will correct this patch, to be applicable, then I will vote to
> include it into mainline.
> 
> Which kernel repository and branch should I use for the AT91 ARM?
> I just want to know - whereto send my next patch to support gms machine?
> 
> Best regards!
> --
> Igor Plyatov
> 

