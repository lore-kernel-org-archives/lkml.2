Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155Ab1BPTyM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 14:54:12 -0500
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:60233 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752726Ab1BPTyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 14:54:11 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=laWpxaq4H4p1YkU4NGYra2hnh5G+W6PxBe8Mg64rnlSwF1yUKvxk28wzaedyio6jtiu1Ab5tGaHlffQdPy24bWPF6ahkhk9ugirumqZ/Be4h03mQAznUdTuAIOv7FdX4;
Date: Wed, 16 Feb 2011 11:54:06 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Alex Riesen <raa.lkml@gmail.com>
Cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fix backlight brightness on intel LVDS panel after
 reopening lid
Message-ID: <20110216115406.631ada72@jbarnes-desktop>
In-Reply-To: <AANLkTinuF0na0zLOFOjFWapoNNXCUay88BdrxH0-_ybM@mail.gmail.com>
References: <AANLkTi=Mc8O8cNWYOKgD0cESQhfa2jiHor11DBuagJDF@mail.gmail.com>
	<20110216192658.GA7225@blimp.localdomain>
	<AANLkTinuF0na0zLOFOjFWapoNNXCUay88BdrxH0-_ybM@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Feb 2011 20:46:45 +0100
Alex Riesen <raa.lkml@gmail.com> wrote:

> On Wed, Feb 16, 2011 at 20:26, Alex Riesen <raa.lkml@gmail.com> wrote:
> > Linus Torvalds, Wed, Feb 16, 2011 05:16:01 +0100:
> >> Most of the changes are pretty spread out and small, with drivers/gpu
> >> (radeon and i915) somewhat standing out from the pack. ...
> >
> > The backlight level on this Dell XPS M1330 reduces every time I reopen
> > the lid, and BIOS does not seem to know anything about that (the
> > keyboard shortcuts to set backlight brightness cause it to jump to the
> > level next to the one set before closing the lid).
> 
> It is this bug, I believe:
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=25072
> 
> I somehow missed it at first, and only noticed after sending the patch.

There's also this patch: https://patchwork.kernel.org/patch/499221/.
It got things working on my E6510 again at least.

-- 
Jesse Barnes, Intel Open Source Technology Center
