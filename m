Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759307Ab2C2Mi5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 08:38:57 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:39804 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758338Ab2C2Miu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 08:38:50 -0400
Date: Thu, 29 Mar 2012 14:39:32 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Tony Vroon <tony@linx.net>
Cc: Dave Airlie <airlied@linux.ie>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org, Matt Turner <mattst88@gmail.com>
Subject: Re: [git pull] drm main pull for 3.4-rc1
Message-ID: <20120329123932.GB20275@phenom.ffwll.local>
Mail-Followup-To: Tony Vroon <tony@linx.net>,
	Dave Airlie <airlied@linux.ie>,
	DRI mailing list <dri-devel@lists.freedesktop.org>,
	linux-kernel@vger.kernel.org, Matt Turner <mattst88@gmail.com>
References: <alpine.DEB.2.00.1203211024490.22265@skynet.skynet.ie>
 <4F70764F.7030409@linx.net>
 <20120326143250.GN4014@phenom.ffwll.local>
 <4F7080D1.4050400@linx.net>
 <20120327193124.GA1971@phenom.ffwll.local>
 <20120327203913.GA2436@phenom.ffwll.local>
 <4F72D1ED.8040305@linx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F72D1ED.8040305@linx.net>
X-Operating-System: Linux phenom 3.2.0-1-amd64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2012 at 09:55:09AM +0100, Tony Vroon wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On 27/03/12 21:39, Daniel Vetter wrote:
> > Yet another thing to try: Can you append intel_iommu=igfx_off to
> > your kernel cmdline? If you can, try this both on mainline kernels
> > and with my additional patches.
> 
> To confirm, intel_iommu=igfx_off is stable on both mainline and your
> "for-chainsaw" branch with additional SNB patching.
> 
> With ppgtt and the iommu fully enabled, your SNB patches remove the
> DMAR warnings but do not address the stability problem, in that it
> still crashes in the same way.

Quick check on the things we've talked about yesterday on irc: Is the
for-chainsaw branch plus intel_iommu=igfx_off now stable for you? Or has
it again crashed after a few hours like intel_iommu=igfx_off did on the
mainline kernel?

Thanks a lot for your testing.

Yours, Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
