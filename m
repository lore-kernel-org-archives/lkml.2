Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751679Ab0LVKM2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 05:12:28 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45987 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213Ab0LVKM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 05:12:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=J62LjNGLGaEJr9GsR5KdnlXSOEeQVdAIYP3DZcIeYRHwAJxpnEu4mTieM9u5TQNolK
         2PmMgy1ciEXC+T7qvO6l4d8nxg3wr6coN7Qd2/RnMT7y3BWBUdIRjiwElh+QRgp1a7ZY
         ozxpadKqAsi8WqbuYLAhmIbeb8kMbNVTp+iBE=
Date: Wed, 22 Dec 2010 02:12:19 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Chase Douglas <chase.douglas@canonical.com>
Cc: Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Takashi Iwai <tiwai@suse.de>, Chris Bagwell <chris@cnpbagwell.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] Input: synaptics - ignore bogus mt packet
Message-ID: <20101222101219.GB22590@core.coreip.homeip.net>
References: <1292852364-19127-1-git-send-email-rydberg@euromail.se>
 <1292852364-19127-4-git-send-email-rydberg@euromail.se>
 <4D10D875.5040905@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D10D875.5040905@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 21, 2010 at 11:40:21AM -0500, Chase Douglas wrote:
> On 12/20/2010 08:39 AM, Henrik Rydberg wrote:
> > In multitouch mode, at least one device (fw: 7.4 id: 0x1c0b1) sometimes
> > sends a final main packet with x == 1. Since the normal values are above
> > 1472, this is clearly bogus. At the same time, a two-finger touch is
> > signaled, even though only one finger was on the pad to begin with. This
> > patch ignores the packet altogether, removing the problem.
> > 
> > Acked-by: Chris Bagwell <chris@cnpbagwell.com>
> > Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> 
> Acked-by: Chase Douglas <chase.douglas@canonical.com>

Looks good to me as well.

Acked-by: Dmitry Torokhov <dtor@mail.ru>

-- 
Dmitry
