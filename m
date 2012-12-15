Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752292Ab2LOUmg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 15:42:36 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:55400 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666Ab2LOUmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 15:42:35 -0500
Date: Sat, 15 Dec 2012 18:42:27 -0200
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com,
        Marcos Chaparro <marcos@mrkindustries.com.ar>,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Subject: Re: [PATCH 162/241] Bluetooth: ath3k: Add support for VAIO VPCEH
 [0489:e027]
Message-ID: <20121215204226.GA2870@herton-Z68MA-D2H-B3>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
 <1355407206-17100-163-git-send-email-herton.krzesinski@canonical.com>
 <1355601558.18807.28.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355601558.18807.28.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 15, 2012 at 07:59:18PM +0000, Ben Hutchings wrote:
> On Thu, 2012-12-13 at 11:58 -0200, Herton Ronaldo Krzesinski wrote:
> > 3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Marcos Chaparro <marcos@mrkindustries.com.ar>
> > 
> > commit acd9454433e28c1a365d8b069813c35c1c3a8ac3 upstream.
> > 
> > Added Atheros AR3011 internal bluetooth device found in Sony VAIO VPCEH to the
> > devices list.
> > Before this, the bluetooth module was identified as an Foxconn / Hai bluetooth
> > device [0489:e027], now it claims to be an AtherosAR3011 Bluetooth
> > [0cf3:3005].
> [...]
> 
> This seems to be applicable to 3.{0,2,4,6}.y as well...

While we're here you may also want to consider to add to other stables the
following (where applicable, I didn't verify exactly which versions these
may be needed):

[163/241] drm/i915: EBUSY status handling added to i915_gem_fault().
(reference: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1087302)

[164/241] MISC: hpilo, remove pci_disable_device
(reference: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1087860)

This is what I recall as bugfixes requested to be added directly to me,
but that didn't yet came through as an stable mailing list request.

> 
> Ben.
> 
> -- 
> Ben Hutchings
> Theory and practice are closer in theory than in practice.
>                                 - John Levine, moderator of comp.compilers

-- 
[]'s
Herton
