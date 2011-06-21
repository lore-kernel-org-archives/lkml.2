Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756747Ab1FUPGB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 11:06:01 -0400
Received: from dsl-67-204-24-19.acanac.net ([67.204.24.19]:52925 "EHLO
	mail.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751554Ab1FUPF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 11:05:59 -0400
Date: Tue, 21 Jun 2011 11:05:44 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.0-rc4
Message-ID: <20110621150544.GA2717@elliptictech.com>
References: <BANLkTimiVpKavmKY=rsJP34dMQSq__Xn7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTimiVpKavmKY=rsJP34dMQSq__Xn7g@mail.gmail.com>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On 2011-06-20 21:02 -0700, Linus Torvalds wrote:
> Mostly the usual small driver one- (or few-) liners, and some bigger
> changes to drm (and md). But also two new smallish drivers
> (net/usb/kalmia.c, and the ADP8870 backlight driver). Some filesystem
> fixes (btrfs, cifs, afs, xfs, nfsd).

We're at -rc4 now, but it seems that the following patch (drm/i915: add
missing intel_enable_plane() call to i9xx_crtc_mode_set()) has not made
it in yet?

  http://permalink.gmane.org/gmane.linux.kernel/1148279

The i915 driver has been broken since 3.0-rc1 without this fix,
which has been available for 3 weeks now.

Thanks,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
