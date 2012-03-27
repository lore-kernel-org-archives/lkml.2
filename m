Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757985Ab2C0KAr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 06:00:47 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:46414 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757945Ab2C0KAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 06:00:45 -0400
Date: Tue, 27 Mar 2012 12:01:28 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Tony Vroon <tony@linx.net>
Cc: Dave Airlie <airlied@linux.ie>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org, Matt Turner <mattst88@gmail.com>
Subject: Re: [git pull] drm main pull for 3.4-rc1
Message-ID: <20120327100128.GF4276@phenom.ffwll.local>
Mail-Followup-To: Tony Vroon <tony@linx.net>,
	Dave Airlie <airlied@linux.ie>,
	DRI mailing list <dri-devel@lists.freedesktop.org>,
	linux-kernel@vger.kernel.org, Matt Turner <mattst88@gmail.com>
References: <alpine.DEB.2.00.1203211024490.22265@skynet.skynet.ie>
 <4F70764F.7030409@linx.net>
 <20120326143250.GN4014@phenom.ffwll.local>
 <4F707F05.7000401@linx.net>
MIME-Version: 1.0
In-Reply-To: <4F707F05.7000401@linx.net>
X-Operating-System: Linux phenom 3.2.0-1-amd64
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2012 at 03:36:53PM +0100, Tony Vroon wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On 26/03/12 15:32, Daniel Vetter wrote:
> > Ok, this is ugly. Do you have any special module options for i915
> > set (like i915_enable_rc6)?
> 
> None set:
> adrastea ~ # cat /proc/cmdline
> BOOT_IMAGE=3.3.0-04074-g53 rw root=0
> 
> > Also, can you check whether disabling vt-d does work around the
> > issue?
> 
> Will try. More to follow shortly.
> 
> > Last but not least, can you please bisect where this regression got
> > introduced so we have an idea why it breaks?
> 
> I do not know how to turn these 3.3.0-04074-g5375871 type indicators

If you replace 3.3.0 with v3.3.3 this is exactly what git can parse as a
commit ref. into useful git bisect arguments. Another thing for you to try
is booting with i915.i915_enable_ppgtt=0 (and vt-d enabled of course).

Yours, Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
