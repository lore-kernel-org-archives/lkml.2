Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802Ab2C0UlX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 16:41:23 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:45095 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682Ab2C0UlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 16:41:22 -0400
Date: Tue, 27 Mar 2012 22:39:13 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Tony Vroon <tony@linx.net>
Cc: Dave Airlie <airlied@linux.ie>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org, Matt Turner <mattst88@gmail.com>
Subject: Re: [git pull] drm main pull for 3.4-rc1
Message-ID: <20120327203913.GA2436@phenom.ffwll.local>
Mail-Followup-To: Tony Vroon <tony@linx.net>,
	Dave Airlie <airlied@linux.ie>,
	DRI mailing list <dri-devel@lists.freedesktop.org>,
	linux-kernel@vger.kernel.org, Matt Turner <mattst88@gmail.com>
References: <alpine.DEB.2.00.1203211024490.22265@skynet.skynet.ie>
 <4F70764F.7030409@linx.net>
 <20120326143250.GN4014@phenom.ffwll.local>
 <4F7080D1.4050400@linx.net>
 <20120327193124.GA1971@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120327193124.GA1971@phenom.ffwll.local>
X-Operating-System: Linux phenom 3.2.0-1-amd64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 27, 2012 at 09:31:24PM +0200, Daniel Vetter wrote:
> On Mon, Mar 26, 2012 at 03:44:33PM +0100, Tony Vroon wrote:
> > -----BEGIN PGP SIGNED MESSAGE-----
> > Hash: SHA1
> > 
> > On 26/03/12 15:32, Daniel Vetter wrote:
> > > Also, can you check whether disabling vt-d does work around the
> > > issue?
> > 
> > Yes, that does appear to stay operational for longer on:
> > Linux adrastea 3.3.0-06972-ge22057c #1 SMP PREEMPT Mon Mar 26 11:29:21
> > BST 2012 x86_64 Intel(R) Core(TM) i7-2620M CPU @ 2.70GHz GenuineIntel
> > GNU/Linux
> > 
> > Obviously I would like to have x2apic and my IOMMU back...
> 
> Can you try out the for-chainsaw branch from
> 
> git://people.freedesktop.org/~danvet/drm
> 
> Afaics it seems to help here on my snb with VT-d enabled. But that means
> it'll still crash eventually with tons of DMAR fault message (like yours).
> But compared to previous kernels it now doesn't insta-die for me. So no
> high hopes, please, but it would be interesting to know how this fares for
> you.
> 
> Meanwhile I'll be trying a few other funky tricks.

Yet another thing to try: Can you append intel_iommu=igfx_off to your
kernel cmdline? If you can, try this both on mainline kernels and with my
additional patches.
-Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
