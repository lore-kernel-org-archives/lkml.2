Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924Ab2CKHUt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 03:20:49 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:37436 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333Ab2CKHUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 03:20:48 -0400
MIME-Version: 1.0
In-Reply-To: <20120310202242.384865299@osadl.org>
References: <20120310202014.828058552@osadl.org>
	<20120310202242.384865299@osadl.org>
Date: Sun, 11 Mar 2012 07:20:47 +0000
Message-ID: <CAPM=9tywM0_sroYKJxnZxXEZhcz3VfmG8eqSLUqpNHEdSwy_Qg@mail.gmail.com>
Subject: Re: [PATCH 2/3] drivers-gpu-drm-add-disable-enable-connector.patch
From: Dave Airlie <airlied@gmail.com>
To: Carsten Emde <C.Emde@osadl.org>
Cc: David Airlie <airlied@linux.ie>, Thomas Gleixner <tglx@linutronix.de>,
        DRI <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 10, 2012 at 8:20 PM, Carsten Emde <C.Emde@osadl.org> wrote:
> Some recent integrated graphics chipset, notably Intel's "Pineview", also
> provide on-chip LVDS support. As an extra service, the LVDS interface supplies
> EDID data - irrespective of whether an LVDS panel is connected or not. The
> drm_mode_getresources() function, therefore, causes Xorg to always include
> the LVDS panel into the display and initialize a separate screen for it. e.g.
> (II) intel(0): Output LVDS1 connected
> (II) intel(0): Output VGA1 connected
> (II) intel(0): Using spanning desktop for initial modes
> (II) intel(0): Output LVDS1 using initial mode 1024x768 +0+0
> (II) intel(0): Output VGA1 using initial mode 1280x1024 +1024+0
> which is not what you want, if the only connected screen is a VGA monitor.
> One would assume that the BIOS settings of such systems would allow to
> separately enable or disable LVDS support; unfortunately, systems have been
> found in the wild that do not provide this feature.

So video=LVDS-1:d doesn't work for you?

Dave.
