Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760335Ab2COLWA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 07:22:00 -0400
Received: from HSI-KBW-109-192-167-159.hsi6.kabel-badenwuerttemberg.de ([109.192.167.159]:60296
	"EHLO rack0slot8.osadl.org" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756336Ab2COLV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 07:21:58 -0400
Message-Id: <20120315111947.621891613@osadl.org>
User-Agent: quilt/0.48-1
Date: Thu, 15 Mar 2012 12:19:47 +0100
From: Carsten Emde <C.Emde@osadl.org>
To: David Airlie <airlied@linux.ie>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Keith Packard <keithp@keithp.com>,
        Paul Menzel <paulepanter@users.sourceforge.net>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Carsten Emde <C.Emde@osadl.org>, DRI <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [V4 PATCH 0/2] Provide workarounds to use DRM/KMS with broken graphics hardware
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes from V3 to V4:

Reverted the removal of the "brightness_inverted" parameter of the i915
module as suggested by Chris. Inversion of the sense of the brightness
variable is now enabled, if either the quirked notebook is encountered
or the "brightness_inverted" module parameter switch is set.

Thanks,
	-Carsten.

