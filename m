Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757128Ab0CPCm6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 22:42:58 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:39091 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755259Ab0CPCmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 22:42:54 -0400
Date: Tue, 16 Mar 2010 11:41:54 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Dave Airlie <airlied@gmail.com>
Cc: Jordan Crouse <jcrouse@codeaurora.org>, dri-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] drm: Allow platform devices to register as DRM devices
Message-ID: <20100316024154.GC17028@linux-sh.org>
References: <4B8BE42C.1090401@codeaurora.org> <4B8BE489.7020402@codeaurora.org> <21d7e9971003141756l51d9e971x83b8b8cfbb0de25@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21d7e9971003141756l51d9e971x83b8b8cfbb0de25@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 15, 2010 at 10:56:02AM +1000, Dave Airlie wrote:
> On Tue, Mar 2, 2010 at 2:00 AM, Jordan Crouse <jcrouse@codeaurora.org> wrote:
> >
> > Allow platform devices without PCI resources to be DRM devices.
> >
> > Signed-off-by: Jordan Crouse <jcrouse@codeaurora.org>
> 
> This patch has a bunch of whitespace damage at least in my inbox and
> also in patchwork
> 
> Please also be careful with the places you add copyrights, you moved a
> bunch of code from drm_drv.c to drm_pci.c and added a copyright for
> Code Aurora in drm_pci.c? You can only assert copyright if you actually
> wrote the code, otherwise the patch contains your authorship details
> and who contributed the code. I'm guessing you might have copyright
> over one file in this that being drm_platform.c, the rest I'm less sure
> about.
> 
> I also wonder if we could/should separate the arm drm support out from
> this patch (i.e.  the __arm__ changes).
> 
Also note that pgprot_noncached() is a standard interface these days, so
there is no longer any reason to special case it. There's no reason for
the io prot mapping code turning in to the hell that was the fbmem.c
mmap.
