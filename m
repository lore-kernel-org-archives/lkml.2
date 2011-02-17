Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926Ab1BQWNi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 17:13:38 -0500
Received: from eazy.amigager.de ([213.239.192.238]:55689 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963Ab1BQWNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 17:13:36 -0500
Date: Thu, 17 Feb 2011 23:13:29 +0100
From: Tino Keitel <scorpion@vger.kernel.org>
To: Alex Riesen <raa.lkml@gmail.com>
Cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fix backlight brightness on intel LVDS panel after
 reopening lid
Message-ID: <20110217221329.GA3332@x61.home>
Mail-Followup-To: Alex Riesen <raa.lkml@gmail.com>,
	DRI mailing list <dri-devel@lists.freedesktop.org>,
	Chris Wilson <chris@chris-wilson.co.uk>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <AANLkTi=Mc8O8cNWYOKgD0cESQhfa2jiHor11DBuagJDF@mail.gmail.com>
 <20110216192658.GA7225@blimp.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110216192658.GA7225@blimp.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 16, 2011 at 20:26:58 +0100, Alex Riesen wrote:
> Signed-off-by: Alex Riesen <raa.lkml@gmail.com>
> 
> ---
> Linus Torvalds, Wed, Feb 16, 2011 05:16:01 +0100:
> > Most of the changes are pretty spread out and small, with drivers/gpu
> > (radeon and i915) somewhat standing out from the pack. ... 
> 
> The backlight level on this Dell XPS M1330 reduces every time I reopen the
> lid, and BIOS does not seem to know anything about that (the keyboard
> shortcuts to set backlight brightness cause it to jump to the level next to
> the one set before closing the lid).

Hi,

with kernel 2.6.37, the display brightness of my ThinkPad X61s was
always reduced after lid open, resume from suspend etc.  With this
patch on top of 2.6.38-rc5, the problem is gone.  Thanks.

Regards,
Tino

