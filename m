Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756417Ab1CWOar (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 10:30:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36023 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754249Ab1CWOap (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 10:30:45 -0400
Date: Wed, 23 Mar 2011 07:27:19 -0700
From: Greg KH <gregkh@suse.de>
To: Par-Gunnar Hjalmdahl <par-gunnar.p.hjalmdahl@stericsson.com>
Cc: devel@driverdev.osuosl.org, Linus Walleij <linus.walleij@linaro.org>,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        Pavan Savoy <pavan_savoy@sify.com>, Vitaly Wool <vitalywool@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Marcel Holtmann <marcel@holtmann.org>,
        Lukasz Rymanowski <Lukasz.Rymanowski@tieto.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Par-Gunnar Hjalmdahl <pghatwork@gmail.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 2/2] mach-ux500: Add CG2900 devices
Message-ID: <20110323142719.GA17369@suse.de>
References: <1300888803-26474-1-git-send-email-par-gunnar.p.hjalmdahl@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300888803-26474-1-git-send-email-par-gunnar.p.hjalmdahl@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 03:00:03PM +0100, Par-Gunnar Hjalmdahl wrote:
> This patch adds the board specific data for the CG2900
> driver on a UX500 board.
> 
> Signed-off-by: Par-Gunnar Hjalmdahl <par-gunnar.p.hjalmdahl@stericsson.com>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  arch/arm/mach-ux500/Makefile         |    4 +
>  arch/arm/mach-ux500/board-mop500.c   |  160 ++++++++++++++++
>  arch/arm/mach-ux500/devices-cg2900.c |  349 ++++++++++++++++++++++++++++++++++
>  arch/arm/mach-ux500/devices-cg2900.h |   19 ++
>  4 files changed, 532 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/mach-ux500/devices-cg2900.c
>  create mode 100644 arch/arm/mach-ux500/devices-cg2900.h

As this touches ARM specific code, I need an ack from the ARM maintainer
before I can take this through the staging tree.  Is there any way to
make it part of your drivers/staging/ submission?  There are other
examples in the staging tree already that do this, why not do that here
as well?

thanks,

greg k-h
