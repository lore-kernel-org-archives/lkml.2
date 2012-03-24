Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040Ab2CXTPu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 15:15:50 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:47488 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754689Ab2CXTPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 15:15:48 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1203211024490.22265@skynet.skynet.ie>
References: <alpine.DEB.2.00.1203211024490.22265@skynet.skynet.ie>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 24 Mar 2012 12:15:27 -0700
X-Google-Sender-Auth: sri_Vgw40TJ1Cke6F-z2PdDFDxU
Message-ID: <CA+55aFzHEuXoejUSTgXbzr4m4t-C+r0HBRCmB0RuCiW-ndQv1g@mail.gmail.com>
Subject: Re: [git pull] drm main pull for 3.4-rc1
To: Dave Airlie <airlied@linux.ie>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Alan Cox <alan@linux.intel.com>
Cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Btw, I think this came in through the DRM merge:

  ERROR: "mdfld_set_brightness" [drivers/gpu/drm/gma500/gma500_gfx.ko]
undefined!
  make[1]: *** [__modpost] Error 1
  make: *** [modules] Error 2

this is just "make ARCH=i386" with allmodconfig.

                       Linus

On Wed, Mar 21, 2012 at 3:47 AM, Dave Airlie <airlied@linux.ie> wrote:
>
> This is the main drm pull request, I'm probably going to send two more
> smaller ones, will explain below.
