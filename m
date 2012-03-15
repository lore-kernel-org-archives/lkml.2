Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965293Ab2COO7G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 10:59:06 -0400
Received: from HSI-KBW-109-192-167-159.hsi6.kabel-badenwuerttemberg.de ([109.192.167.159]:38397
	"EHLO rack0slot8.osadl.org" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932104Ab2COO7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 10:59:01 -0400
Message-Id: <20120315145623.486070468@osadl.org>
User-Agent: quilt/0.48-1
Date: Thu, 15 Mar 2012 15:56:23 +0100
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
Subject: [V5 PATCH 0/4] Provide workarounds to use DRM/KMS with broken graphics hardware
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes from V4 to V5:

1. Split the previous patch 2/2 into three patches to separately i) add the
module parameter, ii) add the quirk infrastructure, and iii) actually quirk
the related machine.

2. Rename the module parameter variable to i915_panel_invert_brightness.

3. Make the module parameter variable tristate to either ignore the
quirk, consider the quirk, if any, or force inversion.

4. Print an instruction along the description of the module parameter to
encourage people sending machine data, should another machine be found
that needs to be quirked.

5. Introduce the function intel_panel_compute_brightness where the
brightness calculation is handled.

Thanks, Chris, for these very valuable suggestions.

	-Carsten.

