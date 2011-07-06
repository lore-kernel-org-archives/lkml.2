Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994Ab1GFX7d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 19:59:33 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:35900 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753635Ab1GFX7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 19:59:32 -0400
X-Sasl-enc: QuodiPy56nfBySOKTXEGKBAwB+cZL0LjyMw1z+JhrkNO 1309996771
Date: Wed, 6 Jul 2011 16:56:46 -0700
From: Greg KH <greg@kroah.com>
To: reimth@googlemail.com
Cc: Dave Airlie <airlied@redhat.com>, Alex Deucher <alexdeucher@gmail.com>,
        Mario Kleiner <mario.kleiner@tuebingen.mpg.de>,
        Jean Delvare <khali@linux-fr.org>,
        Tyson Whitehead <twhitehead@gmail.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Thomas Reim <rdratlos@yahoo.co.uk>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, stable@kernel.org
Subject: Re: [stable] [PATCH 1/3] drm: Separate EDID Header Check from EDID
 Block Check
Message-ID: <20110706235646.GC22814@kroah.com>
References: <CADnq5_M5NAd2PVbS0FPB_VSmg8+41HUsDL1TcbKK94GK6MF_jA@mail.gmail.com>
 <1309995012-5873-4-git-send-email-reimth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309995012-5873-4-git-send-email-reimth@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 07, 2011 at 01:30:12AM +0200, reimth@googlemail.com wrote:
> From: Thomas Reim <rdratlos@yahoo.co.uk>
> 
>     Provides function drm_edid_header_is_valid() for EDID header check
>     and replaces EDID header check part of function drm_edid_block_valid()
>     by a call of drm_edid_header_is_valid().
>     This is a prerequisite to extend DDC probing, e. g. in function
>     radeon_ddc_probe() for Radeon devices, by a central EDID header check.
> 
>     Tested for kernel 2.35, 2.38 and 3.0
> 
> Signed-off-by: Thomas Reim <rdratlos@yahoo.co.uk>
> ---
>  drivers/gpu/drm/drm_edid.c |   24 ++++++++++++++++++------
>  include/drm/drm_crtc.h     |    1 +
>  2 files changed, 19 insertions(+), 6 deletions(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>

Same goes for 2/3 and 3/3 as well.
