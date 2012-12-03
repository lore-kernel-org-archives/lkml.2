Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755113Ab2LCPYf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 10:24:35 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:41911 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215Ab2LCPYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 10:24:34 -0500
MIME-Version: 1.0
In-Reply-To: <20121203143156.904709715@decadent.org.uk>
References: <20121203143146.549859007@decadent.org.uk>
	<20121203143156.904709715@decadent.org.uk>
Date: Mon, 3 Dec 2012 10:24:33 -0500
Message-ID: <CA+5PVA6P9EDYgt2WSXyX_fNsN26rG3a9j=7vk4b2SncwQ7am+A@mail.gmail.com>
Subject: Re: [ 67/89] drm/radeon: properly track the crtc not_enabled case evergreen_mc_stop()
From: Josh Boyer <jwboyer@gmail.com>
To: Ben Hutchings <ben@decadent.org.uk>, Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexander.deucher@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 3, 2012 at 9:32 AM, Ben Hutchings <ben@decadent.org.uk> wrote:
> 3.2-stable review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
> From: Alex Deucher <alexander.deucher@amd.com>
>
> commit 804cc4a0ad3a896ca295f771a28c6eb36ced7903 upstream.
>
> The save struct is not initialized previously so explicitly
> mark the crtcs as not used when they are not in use.
>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>

Hm.  If this is needed in 3.2, presumably it's needed in 3.6 as well.  I
don't see it queued for 3.6.9, and the Cc: tag is there.

Greg, Alex, was this just something that was missed, or am I wrong about
it needing to go into 3.6?

josh
