Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758517Ab2COKao (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 06:30:44 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:50122 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753570Ab2COKai convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 06:30:38 -0400
MIME-Version: 1.0
In-Reply-To: <20120315095357.087317967@osadl.org>
References: <20120315095219.520461363@osadl.org>
	<20120315095357.087317967@osadl.org>
Date: Thu, 15 Mar 2012 11:30:36 +0100
Message-ID: <CAE2SPAaz4oa7q4UTZ=iiKGv3v8=6xT_=odgMN-mrH9enRP26qQ@mail.gmail.com>
Subject: Re: [V3 PATCH 1/2] drivers-gpu-drm-allow-to-load-edid-firmware.patch
From: Bastien ROUCARIES <roucaries.bastien@gmail.com>
To: Carsten Emde <C.Emde@osadl.org>
Cc: David Airlie <airlied@linux.ie>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Keith Packard <keithp@keithp.com>,
        Paul Menzel <paulepanter@users.sourceforge.net>,
        DRI <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 10:52 AM, Carsten Emde <C.Emde@osadl.org> wrote:
> Broken monitors and/or broken graphic boards may send erroneous or no
> EDID data. This also applies to broken KVM devices that are unable to
> correctly forward the EDID data of the connected monitor but invent
> their own fantasy data.
>
> This patch allows to specify an EDID data set to be used instead of
> probing the monitor for it. It contains built-in data sets of frequently
> used screen resolutions. In addition, a particular EDID data set may be
> provided in the /lib/firmware directory and loaded via the firmware
> interface. The name is passed to the kernel as module parameter of the
> drm_kms_helper module either when loaded
>  options drm_kms_helper edid_firmware=edid/1280x1024.bin
> or as kernel commandline parameter
>  drm_kms_helper.edid_firmware=edid/1280x1024.bin

Windows allow vendor to override eddid based on 3 bytes manufacturer
and product code.

Seems a reasonnable approach to follow.

Bastien
