Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667Ab1IUP6t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 11:58:49 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:56130 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392Ab1IUP6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 11:58:48 -0400
MIME-Version: 1.0
In-Reply-To: <201109211612.33504.arnd@arndb.de>
References: <1315846025-11453-1-git-send-email-ohad@wizery.com>
	<CAK=Wgbam6u1bq8fG+oMUhxfWH1g3dU7q+VhPWFEZOLgFMV_3vQ@mail.gmail.com>
	<20110920231340.GT18894@atomide.com>
	<201109211612.33504.arnd@arndb.de>
Date: Wed, 21 Sep 2011 17:53:22 +0200
Message-ID: <CACRpkdbqVuFEgntw=bUYka5NuvpbPhjB8L0cD4CTmsjwoZBDSA@mail.gmail.com>
Subject: Re: [PATCH 00/10] hwspinlock-next
From: Linus Walleij <linus.walleij@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>, Ohad Ben-Cohen <ohad@wizery.com>
Cc: Tony Lindgren <tony@atomide.com>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Nicolas Pitre <nico@fluxnic.net>, Thomas Gleixner <tglx@linutronix.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 21, 2011 at 4:12 PM, Arnd Bergmann <arnd@arndb.de> wrote:

> My feeling is that it would be best for Ohad to send these directly
> to Linus, since it's basically a standalone subsystem and he's listed
> as the maintainer (well, after this series at least).

I agree. That's the path of least resistance and trouble.

If/when ARM-specific driver subsystems need their own zuper-maintainer
we can deal with it, can't we? There aren't many of them yet.

Yours,
Linus Walleij
